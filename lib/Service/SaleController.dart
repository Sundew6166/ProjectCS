import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/ImageController.dart';
import 'package:my_book/Service/NotificationController.dart';

class SaleController {
  Future<void> addSale(String idBook, String detail, String sellingPrice, String deliveryFee, String bank, String bankAccountNumber, File image) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    String downloadURL = await ImageController()
        .uploadToFireStorage(image, "${idBook}_${user!.uid}");
    final data = {
      "book": idBook,
      "detail": detail,
      "sellingPrice": int.parse(sellingPrice),
      "deliveryFee": int.parse(deliveryFee),
      "bank": bank,
      "bankAccountNumber": bankAccountNumber,
      "image": downloadURL,
      "seller": user.uid,
      "saleStatus": "N",
      "createDateTime": Timestamp.now(),
      "updateDateTime": "",
      "buyer": "",
      "paymentSlip": "",
    };

    await db.collection('sales').add(data);
  }

  Future<List<Map<String, dynamic>?>> getMySale() async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>?> output = [];

    await db
        .collection('sales')
        .where('seller', isEqualTo: user!.uid)
        .where('saleStatus', whereIn: ['N', 'B'])
        .get()
        .then((querySnapshot) async {
          for (var docSnap in querySnapshot.docs) {
            var data = await getBookInfo(docSnap.data(), docSnap.id);
            output.add(data);
          }
        });
    output.sort((a, b) => b!['createDateTime'].compareTo(a!['createDateTime']));

    return output;
  }

  Future<bool> checkHasSale(String isbn, String edition) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    bool hasSale = false;

    await db
        .collection('sales')
        .where('seller', isEqualTo: user!.uid)
        .where('book', isEqualTo: '${isbn}_${edition}')
        .get()
        .then((value) {
      for (var docSnap in value.docs) {
        if (docSnap.data()['saleStatus'] != 'Y') hasSale = true;
      }
    });
    return hasSale;
  }

  Future<List<Map<String, dynamic>?>> getAllSale() async {
    final db = FirebaseFirestore.instance;
    List<Map<String, dynamic>?> output = [];

    await db
        .collection('sales')
        .where('saleStatus', isEqualTo: "N")
        .get()
        .then((querySnapshot) async {
      for (var docSnap in querySnapshot.docs) {
        var data = await getBookInfo(docSnap.data(), docSnap.id);
        output.add(data);
      }
    });
    output.sort((a, b) => b!['createDateTime'].compareTo(a!['createDateTime']));

    return output;
  }

  Future<Map<String, dynamic>?> getBookInfo(Map<String, dynamic>? data, String id) async {
    if (data != null) {
      data['createDateTime'] = DateFormat('dd/MM/yyyy \n kk:mm')
          .format(data['createDateTime'].toDate());
      data['id'] = id;
      var idSplit = data['book'].split("_");
      await BookController()
          .getBookInfo(idSplit[0], idSplit[1])
          .then((value) => data['book'] = {
                'title': value!['title'],
                'author': value['author'],
                'publisher': value['publisher'],
                'isbn': value['isbn'],
                'edition': value['edition'],
                'synopsys': value['synopsys'],
                'types': value['types']
              });
    }
    return data;
  }

  Future<bool> buyBook(String idSale) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    var docSnap = await db.collection('sales').doc(idSale).get();
    if (docSnap.data()!['saleStatus'] == "N") {
      await db.collection('sales').doc(idSale).update({
        "buyer": user!.uid,
        "saleStatus": "B",
        "updateDateTime": Timestamp.now()
      });
      await NotificationController().createNotification("P", idSale, user.uid);
      print("setTimeout");
      FirebaseFunctions.instance
          .httpsCallable('paymentTimeout')
          .call({"idSale": idSale});
      return true;
    }
    return false;
  }

  Future<void> informPayment(String idSale, File paymentSlip) async {
    final db = FirebaseFirestore.instance;
    String downloadURL = await ImageController()
        .uploadToFireStorage(paymentSlip, "slip_" + idSale);
    var docSnap = await db.collection('sales').doc(idSale).get();
    if (docSnap.data()!['saleStatus'] == "B") {
      await db.collection('sales').doc(idSale).update({
        "paymentSlip": downloadURL,
        "saleStatus": "Y",
        "updateDateTime": Timestamp.now()
      });
      await NotificationController()
          .createNotification("S", idSale, docSnap.data()!['seller']);
    }
  }

  Future<List<dynamic>?> getMyHistory() async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    List<dynamic>? output = [];

    await db
        .collection('sales')
        .where('seller', isEqualTo: user!.uid)
        .where('saleStatus', isEqualTo: "Y")
        .get()
        .then((querySnapshot) async {
      for (var docSnap in querySnapshot.docs) {
        var data = await getBookInfo(docSnap.data(), docSnap.id);
        Map<String, dynamic> temp = {
          'id': docSnap.id,
          "updateDateTime": DateFormat('dd/MM/yyyy-kk:mm')
              .format(docSnap['updateDateTime'].toDate()),
          "total":
              docSnap.data()['deliveryFee'] + docSnap.data()['sellingPrice'],
          "title": data!['book']['title'],
          'status': 'ขาย',
          'createDateTime': docSnap.data()['createDateTime']
        };
        output.add(temp);
      }
    });
    await db
        .collection('sales')
        .where('buyer', isEqualTo: user.uid)
        .where('saleStatus', isEqualTo: "Y")
        .get()
        .then((querySnapshot) async {
      for (var docSnap in querySnapshot.docs) {
        var data = await getBookInfo(docSnap.data(), docSnap.id);
        Map<String, dynamic> temp = {
          'id': docSnap.id,
          "updateDateTime": DateFormat('dd/MM/yyyy-kk:mm')
              .format(docSnap['updateDateTime'].toDate()),
          "total":
              docSnap.data()['deliveryFee'] + docSnap.data()['sellingPrice'],
          "title": data!['book']['title'],
          'status': 'ซื้อ',
          'createDateTime': docSnap.data()['createDateTime']
        };
        output.add(temp);
      }
    });
    output.sort((a, b) => b!['createDateTime'].compareTo(a!['createDateTime']));

    return output;
  }
}

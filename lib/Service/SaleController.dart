import 'dart:io';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/ImageController.dart';
import 'package:workmanager/workmanager.dart';

class SaleController {
  Future<void> addSale(
      String idBook,
      String detail,
      String sellingPrice,
      String deliveryFee,
      String bank,
      String bankAccountNumber,
      File image) async {
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

    await db.collection('sales')
      .where('seller', isEqualTo: user!.uid)
      .get().then((querySnapshot) async {
        for (var docSnap in querySnapshot.docs) {
          var data = docSnap.data();
          data['createDateTime'] = DateFormat('dd/MM/yyyy \n kk:mm').format(data['createDateTime'].toDate());
          data['id'] = docSnap.id;
          var idSplit = data['book'].split("_");
          await BookController().getBookInfo(idSplit[0], idSplit[1])
            .then((value) => data['book'] = {
                  'title': value!['title'],
                  'author': value['author'],
                  'publisher': value['publisher'],
                  'isbn': value['isbn'],
                  'edition': value['edition'],
                  'synopsys': value['synopsys'],
                  'types': value['types']
                });
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
      if (value.docs.isNotEmpty) hasSale = true;
    });
    return hasSale;
  }

  Future<List<Map<String, dynamic>?>> getAllSale() async {
    final db = FirebaseFirestore.instance;
    List<Map<String, dynamic>?> output = [];

    await db.collection('sales')
      .where('saleStatus', isEqualTo: "N")
      .get().then((querySnapshot) async {
        for (var docSnap in querySnapshot.docs) {
          var data = docSnap.data();
          data['createDateTime'] = DateFormat('dd/MM/yyyy \n kk:mm').format(data['createDateTime'].toDate());
          data['id'] = docSnap.id;
          var idSplit = data['book'].split("_");
          await BookController().getBookInfo(idSplit[0], idSplit[1])
            .then((value) => data['book'] = {
                  'title': value!['title'],
                  'author': value['author'],
                  'publisher': value['publisher'],
                  'isbn': value['isbn'],
                  'edition': value['edition'],
                  'synopsys': value['synopsys'],
                  'types': value['types']
                });
        output.add(data);
      }
    });
    output.sort((a, b) => b!['createDateTime'].compareTo(a!['createDateTime']));

    return output;
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
      print("setTimeout");
      Workmanager().registerOneOffTask(idSale, "paymentTimeout", initialDelay: Duration(minutes: 5), inputData: {'idSale': idSale});
      return true;
    }
    return false;
  }

  Future<void> paymentTimeout(String idSale) async {
    final db = FirebaseFirestore.instance;

    var docSnap = await db.collection('sales').doc(idSale).get();
    if (docSnap.data()!['saleStatus'] == "B") {
      await db.collection('sales').doc(idSale).update({
        "buyer": "",
        "saleStatus": "N",
        "updateDateTime": Timestamp.now()
      });
    }
  }

  // Future<void> informPayment(String idSale) async {
  //   final db = FirebaseFirestore.instance;

  //   var docSnap = await db.collection('sales').doc(idSale).get();
  //   if (docSnap.data()!['saleStatus'] == "B") {
  //     Workmanager().cancelByUniqueName(idSale);
  //     await db.collection('sales').doc(idSale).update({
  //       "saleStatus": "Y",
  //       "updateDateTime": Timestamp.now()
  //     });
  //   }
  // }
}
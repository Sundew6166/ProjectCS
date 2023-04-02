import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_book/Service/BookController.dart';

class NotificationController {
  Future<void> createNotification(
      String type, String refId, String sendTo) async {
    final db = FirebaseFirestore.instance;

    final data = {
      "type": type,
      "ref": refId,
      "sendTo": sendTo,
      "dateTime": Timestamp.now(),
      "isRead": false
    };

    await db.collection('notifications').add(data);
  }

  Future<List> getNotificationInformation(List<dynamic> notiList) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    for (var noti in notiList) {
      noti['dateTime'] = noti['dateTime'].toDate();
      if (noti['type'] == "A") {
        var idSplit = noti['ref'].split("_");
        await BookController()
            .getBookInfo(idSplit[0], idSplit[1])
            .then((value) {
          noti['moreInfo'] = value;
        });
      } else if (noti['type'] == "P" && DateTime.now().isAfter(noti['dateTime'].add(const Duration(minutes: 5)))) {
        await db.collection('notification').doc(noti['id']).update({
          'isRead': true
        });
      } else {
        await db.collection("sales").doc(noti['ref']).get()
          .then((value) async {
            var moreInfo = {
              "idSales": value.id,
              "book": value.data()!['book'],
              "buyer": noti['type'] == "S" ? value.data()!['buyer'] : user!.uid,
              "sellingPrice": value.data()!['sellingPrice'],
              "deliveryFee": value.data()!['deliveryFee'],
              "bank": value.data()!['bank'],
              "bankAccountNumber": value.data()!['bankAccountNumber']
            };
            await db
                .collection("books")
                .doc(moreInfo['book'])
                .get()
                .then((value) {
              moreInfo["title"] = value.data()!['title'];
            });
            await db
                .collection("accounts")
                .doc(moreInfo['buyer'])
                .get()
                .then((value) {
              moreInfo["deliveryInfo"] =
                  "${value.data()!['name']}\n${value.data()!['address']}\nเบอร์โทรศัพท์ ${value.data()!['phone']}";
            });
            noti['moreInfo'] = moreInfo;
        });
      }
    }
    
    notiList.sort((a, b) => b!['dateTime'].compareTo(a!['dateTime']));
    return notiList;
  }

  Future<Map<String, dynamic>> getNotiRead() async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> output = {
      "newNoti" : false,
      "notiList" : []
    };

    await db
        .collection('notifications')
        .where('sendTo', isEqualTo: user!.uid)
        .get()
        .then((querySnapshot) async {
      for (var docSnap in querySnapshot.docs) {
        var data = docSnap.data();
        data.addAll({'id' : docSnap.id});
        output['notiList'].add(data);
        if (docSnap.data()['isRead'] == false) {
          output['newNoti'] = true;
        }
      }
    });
    return output;
  }
}

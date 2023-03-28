import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_book/Service/BookController.dart';

class NotificationController {
  Future<void> createNotification(String type, String refId, String sendTo) async {
    final db = FirebaseFirestore.instance;

    
    final data = {
      "type" : type,
      "ref" : refId,
      "sendTo" : sendTo,
      "dateTime" : Timestamp.now(),
      "isRead" : false
    };

    await db.collection('notifications').add(data);
  }

  Future<List<Map<String, dynamic>?>> getNotification() async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>?> output = [];

    await db
      .collection('notifications')
      .where('sendTo', isEqualTo: user!.uid)
      .get()
      .then((querySnapshot) async {
        for (var docSnap in querySnapshot.docs) {
          var data = docSnap.data();
          data['dateTime'] = data['dateTime'].toDate();
          if (data['type'] == "A") {
            var idSplit = data['ref'].split("_");
            await BookController().getBookInfo(idSplit[0], idSplit[1]).then((value) {
              data['moreInfo'] = value;
            });
          } else {
            await db.collection("sales").doc(data['ref']).get().then((value) async {
              var moreInfo = {
                "idSales" : value.id,
                "book" : value.data()!['book'],
                "buyer" : data['type'] == "S" ? value.data()!['buyer'] : user.uid,
                "sellingPrice" : value.data()!['sellingPrice'],
                "deliveryFee" : value.data()!['deliveryFee']
              };
              await db.collection("books").doc(moreInfo['book']).get().then((value) {
                moreInfo["title"] = value.data()!['title'];
              });
              await db.collection("accounts").doc(moreInfo['buyer']).get().then((value) {
                moreInfo["deliveryInfo"] = "${value.data()!['name']}\n${value.data()!['address']}\nเบอร์โทรศัพท์ ${value.data()!['phone']}";
              });
              data['moreInfo'] = moreInfo;
            });
          }
          output.add(data);
        }
      });
    output.sort((a, b) => b!['dateTime'].compareTo(a!['dateTime']));
    return output;
  }
}
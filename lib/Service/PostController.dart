import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostController {
  Future<List<dynamic>> getPostAll() async {
    // Future<void> getPostAll() async {
    final db = FirebaseFirestore.instance;
    List<dynamic> output = [];

    await db.collection("posts").get().then((querySnapshot) {
      for (var docSnap in querySnapshot.docs) {
        Map<String, dynamic> temp = {
          "Create_DateTime_Post":
              (docSnap.data()['Create_DateTime_Post']).toDate(),
          "Detail_Post": docSnap.data()['Detail_Post'],
          "CreateBy": docSnap.data()['CreateBy']
        };
        output.add(temp);

        // print('${docSnap.id} => ${docSnap.data()['Create_DateTime_Post']}');
        // DateTime myDateTime = (docSnap.data()['Create_DateTime_Post']).toDate();
        // print(myDateTime);
        // print(docSnap.data()['Detail_Post']);
        // print(docSnap.data()['CreateBy']);
      }
    });
    return output;
  }
}

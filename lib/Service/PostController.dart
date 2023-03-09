import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:my_book/Service/AccountController.dart';

class PostController {
  Future<List<dynamic>> getPostAll() async {
    final db = FirebaseFirestore.instance;
    List<dynamic> output = [];

    await db.collection("posts").get().then((querySnapshot) async {
      for (var docSnap in querySnapshot.docs) {
        Map<String, dynamic> test = await AccountController()
            .getAnotherProfile(docSnap.data()['CreateBy']);

        DateTime now = (docSnap.data()['Create_DateTime_Post']).toDate();
        String formattedDate = DateFormat('yyyy/MM/dd \n kk:mm').format(now);
        // print(formattedDate);

        Map<String, dynamic> temp = {
          "Create_DateTime_Post": formattedDate,
          "Detail_Post": docSnap.data()['Detail_Post'],
          "CreateBy": test['username'],
          'Image': test['imageURL']
        };
        output.add(temp);

        // print('${docSnap.id} => ${docSnap.data()['Create_DateTime_Post']}');
        // DateTime myDateTime = (docSnap.data()['Create_DateTime_Post']).toDate();
        // print(myDateTime);
        // print(docSnap.data()['Detail_Post']);
        // print(docSnap.data()['CreateBy']);

        // print(DateFormat.yMMMd().format(DateTime.now()));
        // Mar 7, 2023
        // DateTime now = DateTime.now();
        // String formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
        // 2023-03-07 – 22:14
      }
    });
    return output;
  }

  Future<List<dynamic>> getMyPost() async {
    User? user = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    List<dynamic> output = [];
    final myposts = await db
        .collection('posts')
        .where('CreateBy', isEqualTo: user!.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        DateTime now = (element.data()['Create_DateTime_Post']).toDate();
        String formattedDate = DateFormat('yyyy/MM/dd \n kk:mm').format(now);
        Map<String, dynamic> temp = {
          "Create_DateTime_Post": formattedDate,
          "Detail_Post": element.data()['Detail_Post'],
          "CreateBy": user.displayName.toString(),
          'Image': user.photoURL.toString()
        };
        output.add(temp);
      }
    });
    return output;
  }

  Future<void> addPost(String detail) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    final data = {
      'CreateBy': user!.uid,
      'Create_DateTime_Post': Timestamp.now(),
      'Detail_Post': detail
    };

    await db.collection('posts').add(data);
  }
}

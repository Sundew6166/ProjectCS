import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:my_book/Service/AccountController.dart';

class PostController {
  Future<List<dynamic>> getPostAll() async {
    final db = FirebaseFirestore.instance;
    List<dynamic> output = [];

    await db.collection("posts").get().then((querySnapshot) async {
      for (var docSnap in querySnapshot.docs) {
        Map<String, dynamic> test = await AccountController()
            .getAnotherProfile(docSnap.data()['CreateBy']);

        Map<String, dynamic> temp = {
          "Create_DateTime_Post":
              (docSnap.data()['Create_DateTime_Post']).toDate(),
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
        Map<String, dynamic> temp = {
          "Create_DateTime_Post":
              (element.data()['Create_DateTime_Post']).toDate(),
          "Detail_Post": element.data()['Detail_Post'],
          "CreateBy": user!.displayName.toString(),
          'Image': user!.photoURL.toString()
        };
        output.add(temp);
      }
      // print(output);
    });
    return output;
  }
}

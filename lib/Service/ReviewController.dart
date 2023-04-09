import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:my_book/Service/AccountController.dart';

class ReviewController {
  Future<List<dynamic>> getReview(String edition, String isbn) async {
    final db = FirebaseFirestore.instance;
    List<dynamic> output = [];
    final id = '${isbn}_${edition}';
    
    await db.collection("reviews").where('ID_Book', isEqualTo: id).get().then(
      (querySnapshot) async {
        for (var docSnap in querySnapshot.docs) {
          Map<String, dynamic> acc = await AccountController()
              .getAnotherProfile(docSnap.data()['CreateBy']);
          DateTime now = (docSnap.data()['Create_DateTime_Review']).toDate();
          String formattedDate = DateFormat('yyyy/MM/dd kk:mm').format(now);
          Map<String, dynamic> temp = {
            "Create_DateTime_Review": formattedDate,
            "Detail_Review": docSnap.data()['Detail_Review'],
            "CreateBy": acc['username'],
            "Image": acc['imageURL'],
            "Rating": docSnap.data()['Rating']
          };
          output.add(temp);
        }
      }
    );
    output.sort((a, b) =>
      b['Create_DateTime_Review'].compareTo(a['Create_DateTime_Review'])
    );
    return output;
  }

  Future<void> addReview(String detail, double rating, String edition, String isbn) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    await db.collection('reviews').add({
      'CreateBy': user!.uid,
      'Create_DateTime_Review': Timestamp.now(),
      'Detail_Review': detail,
      'ID_Book': '${isbn}_${edition}',
      'Rating': rating
    });
  }

  Future<List<Map<String, dynamic>>> getAllReview() async {
    final db = FirebaseFirestore.instance;
    List<Map<String, dynamic>> output = [];

    await db.collection('reviews').get().then((querySnapshot) {
      for (var docSnap in querySnapshot.docs) {
        output.add(docSnap.data());
      }
    });
    return output;
  }
}

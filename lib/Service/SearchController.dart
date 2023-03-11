import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SearchController {
  // Future<List<dynamic>> getPosts(String item) async {
  Future<void> getPosts(String item) async {
    User? user = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    List<dynamic> output = [];
    await db
        .collection('posts')
        .where('Detail_Post', isGreaterThanOrEqualTo: item)
        .where('Detail_Post', isLessThan: item + '')
        .get()
        .then((value) {
      for (var element in value.docs) {
        DateTime now = (element.data()['Create_DateTime_Post']).toDate();
        String formattedDate = DateFormat('yyyy/MM/dd kk:mm').format(now);
        Map<String, dynamic> temp = {
          'ID': element.id,
          "Create_DateTime_Post": formattedDate,
          "Detail_Post": element.data()['Detail_Post'],
          "CreateBy": user!.displayName.toString(),
          'Image': user.photoURL.toString()
        };
        print('temp ->>>>> $temp');
        output.add(temp);
      }
    });
    // print('-> $output');
    output.sort((a, b) =>
        b['Create_DateTime_Post'].compareTo(a['Create_DateTime_Post']));
    // return output;
  }
}

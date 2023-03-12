import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:my_book/Service/BookController.dart';

class SearchController {
  Future<List<dynamic>> getPosts(String item) async {
    User? user = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    List<dynamic> output = [];
    await db.collection('posts').get().then((value) {
      for (var element in value.docs) {
        if (element['Detail_Post'].toLowerCase().contains(item.toLowerCase())) {
          DateTime now = (element.data()['Create_DateTime_Post']).toDate();
          String formattedDate = DateFormat('yyyy/MM/dd\nkk:mm').format(now);
          Map<String, dynamic> temp = {
            'ID': element.id,
            "Create_DateTime_Post": formattedDate,
            "Detail_Post": element.data()['Detail_Post'],
            "CreateBy": user!.displayName.toString(),
            'Image': user.photoURL.toString()
          };
          output.add(temp);
        }
      }
    });
    output.sort((a, b) =>
        b['Create_DateTime_Post'].compareTo(a['Create_DateTime_Post']));
    return output;
  }

  Future<List<dynamic>> getBooks(String item) async {
    User? user = FirebaseAuth.instance.currentUser;
    List<dynamic> allBook = await BookController().getAllBookInLibrary('ADMIN');
    item = item.toLowerCase();

    List<dynamic> output = [];

    for (var element in allBook) {
      if (element['title'].toLowerCase().contains(item) ||
          element['author'].toLowerCase().contains(item) ||
          element['synopsys'].toLowerCase().contains(item)) {
        // print(element);
        output.add(element);
      }
    }
    return output;
  }
}

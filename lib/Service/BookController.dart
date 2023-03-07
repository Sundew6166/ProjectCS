import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_book/Service/ImageController.dart';

class BookController {
  Future<List<String>> getBookTypes() async {
    final db = FirebaseFirestore.instance;
    List<String> output = [];
    
    await db.collection("book_types").get()
      .then((querySnapshot) {
        for (var docSnap in querySnapshot.docs) {
          output.add(docSnap.data()['name']);
        }
      });
    return output;
  }

  Future<void> addNewBookFromUser(String isbn, String title, String author, String publisher, int edition, int price, List<String> types, String synopsys, File? coverImage) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    String id = isbn + "_" + edition.toString();
    String downloadURL = coverImage == null ? "https://firebasestorage.googleapis.com/v0/b/mybook-f9b37.appspot.com/o/defaultCoverImage.png?alt=media&token=68e1aab0-cb95-4af9-a50b-742c8006bd7e" : await ImageController().uploadToFireStorage(coverImage, id);
    final data = {
      "isbn": isbn,
      "edition": edition,
      "title": title,
      "author": author,
      "publisher": publisher,
      "price": price,
      "coverImage": downloadURL,
      "synopsys": synopsys,
      "updateDateTime": Timestamp.now(),
      "approveStatus": false,
      "createBy": user!.uid
    };

    await db.collection('books').doc(id).set(data);
    linkTypeAndBook(id, types);
  }

  void linkTypeAndBook(String bookId, List<String> types) async {
    final db = FirebaseFirestore.instance;

    for(var type in types) {
      print("type: " + type);
      await db.collection('book_types').where("name", isEqualTo: type).get()
        .then((value) {
          if (value.docs.isNotEmpty) {
            print("add b_has_bt");
            db.collection('b_has_bt').add({
              "book": bookId,
              "type": value.docs[0].id
            });
          } else {
            print("add type and b_has_bt");
            db.collection('book_types').add({"name": type})
              .then((value) {
                db.collection('b_has_bt').add({
                  "book": bookId,
                  "type": value.id
                });
              });
          }
        });
    }
  }

  Future<Map<String, dynamic>?> getBookInfo(String isbn, String edition) async {
    final db = FirebaseFirestore.instance;
    final id = '${isbn}_${edition}';
    
    Map<String, dynamic>? bookInfo;
    await db.collection('books').doc(id).get()
      .then((value) => bookInfo = value.data());
    List<String> types = [];
    await db.collection('b_has_bt').where("book", isEqualTo: id).get()
      .then((querySnapshot) async {
        for (var docSnap in querySnapshot.docs) {
          print(docSnap.data()['type']);
          await db.collection('book_types').doc(docSnap.data()['type']).get()
            .then((value) {
              types.add(value.data()!['name']);
            });
        }
        bookInfo!.addAll({"types": types});
      });
    
    print(bookInfo);
    return bookInfo;
  }

  Future<void> addBookToLibrary(String isbn, String edition) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    await db.collection('a_has_b').add({
      "account": user!.uid,
      "book": '${isbn}_${edition}'
    });
  }

  Future<void> deleteBookFromLibrary(String isbn, String edition) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    await db.collection('a_has_b')
      .where('account', isEqualTo: user!.uid)
      .where('book', isEqualTo: '${isbn}_${edition}')
      .get().then((value) {
        db.collection('a_has_b').doc(value.docs[0].id).delete();
      });
  }

  Future<List<int>> getEditionsBook(String isbn) async {
    final db = FirebaseFirestore.instance;
    List<int> edition = [];

    await db.collection('books')
      .where('isbn', isEqualTo: isbn)
      .get().then((querySnapshot) {
        for (var docSnap in querySnapshot.docs) {
          edition.add(docSnap.data()['edition']);
        }
      });
    return edition;
  }

  Future<bool> checkHasBook(String isbn, String edition) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    bool hasBook = false;

    await db.collection('a_has_b')
      .where('account', isEqualTo: user!.uid)
      .where('book', isEqualTo: '${isbn}_${edition}')
      .get().then((value) {
        if(value.docs.isNotEmpty)
          hasBook = true;
      });
    return hasBook;
  }
}
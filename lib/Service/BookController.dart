import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_book/Service/ImageController.dart';
import 'package:my_book/Service/SaleController.dart';

class BookController {
  Future<List<String>> getBookTypes() async {
    final db = FirebaseFirestore.instance;
    List<String> output = [];

    await db.collection("book_types").get().then((querySnapshot) {
      for (var docSnap in querySnapshot.docs) {
        output.add(docSnap.data()['name']);
      }
    });
    return output;
  }

  Future<void> addNewBook(String accType, String isbn, String title, String author, String publisher, int edition, int price, List<String> types, String synopsys, File? coverImage) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    String id = isbn + "_" + edition.toString();
    String downloadURL = coverImage == null
        ? "https://firebasestorage.googleapis.com/v0/b/mybook-f9b37.appspot.com/o/defaultCoverImage.png?alt=media&token=68e1aab0-cb95-4af9-a50b-742c8006bd7e"
        : await ImageController().uploadToFireStorage(coverImage, id);
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
      "approveStatus": accType == "ADMIN" ? true : false,
      "createBy": user!.uid
    };

    await db.collection('books').doc(id).set(data);
    linkTypeAndBook(id, types);
  }

  void linkTypeAndBook(String bookId, List<String> types) async {
    final db = FirebaseFirestore.instance;

    for (var type in types) {
      print("type: " + type);
      await db
          .collection('book_types')
          .where("name", isEqualTo: type)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          print("add b_has_bt");
          db
              .collection('b_has_bt')
              .add({"book": bookId, "type": value.docs[0].id});
        } else {
          print("add type and b_has_bt");
          db.collection('book_types').add({"name": type}).then((value) {
            db.collection('b_has_bt').add({"book": bookId, "type": value.id});
          });
        }
      });
    }
  }

  Future<Map<String, dynamic>?> getBookInfo(String isbn, String edition) async {
    final db = FirebaseFirestore.instance;
    final id = '${isbn}_${edition}';

    Map<String, dynamic>? bookInfo;
    await db
        .collection('books')
        .doc(id)
        .get()
        .then((value) => bookInfo = value.data());
    await getTypesOfBook(id)
        .then((value) => bookInfo!.addAll({"types": value}));

    return bookInfo;
  }

  Future<List<String>> getTypesOfBook(String idBook) async {
    final db = FirebaseFirestore.instance;

    List<String> types = [];
    await db
        .collection('b_has_bt')
        .where("book", isEqualTo: idBook)
        .get()
        .then((querySnapshot) async {
      for (var docSnap in querySnapshot.docs) {
        print(docSnap.data()['type']);
        await db
            .collection('book_types')
            .doc(docSnap.data()['type'])
            .get()
            .then((value) {
          types.add(value.data()!['name']);
        });
      }
    });

    return types;
  }

  Future<void> addBookToLibrary(String isbn, String edition) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    await db.collection('a_has_b').add({
      "account": user!.uid,
      "book": '${isbn}_${edition}',
      "createDateTime": Timestamp.now()
    });
  }

  Future<void> deleteBookFromLibrary(String isbn, String edition) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    await db
        .collection('a_has_b')
        .where('account', isEqualTo: user!.uid)
        .where('book', isEqualTo: '${isbn}_${edition}')
        .get()
        .then((value) {
      db.collection('a_has_b').doc(value.docs[0].id).delete();
    });
  }

  Future<List<String>> getEditionsBook(String isbn) async {
    final db = FirebaseFirestore.instance;
    List<String> editions = [];

    await db
        .collection('books')
        .where('isbn', isEqualTo: isbn)
        .get()
        .then((querySnapshot) {
      for (var docSnap in querySnapshot.docs) {
        editions.add(docSnap.data()['edition'].toString());
      }
      editions.sort();
    });
    return editions;
  }

  Future<bool> checkHasBook(String isbn, String edition) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    bool hasBook = false;

    await db
        .collection('a_has_b')
        .where('account', isEqualTo: user!.uid)
        .where('book', isEqualTo: '${isbn}_${edition}')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) hasBook = true;
    });
    return hasBook;
  }

  Future<void> updateBookInfo(String idBook, String title, String author, String publisher, int price, List<String> oldTypes, List<String> newTypes, String synopsys, String oldCoverImage, File? newCoverImage) async {
    final db = FirebaseFirestore.instance;

    String downloadURL = newCoverImage == null
        ? oldCoverImage
        : await ImageController().uploadToFireStorage(newCoverImage, idBook);
    final data = {
      "title": title,
      "author": author,
      "publisher": publisher,
      "price": price,
      "coverImage": downloadURL,
      "synopsys": synopsys,
      "updateDateTime": Timestamp.now(),
      "approveStatus": true
    };
    await db.collection('books').doc(idBook).update(data);

    for (var type in oldTypes) {
      if (newTypes.contains(type)) {
        oldTypes.remove(type);
        newTypes.remove(type);
      }
    }
    for (var type in oldTypes) {
      await db
          .collection('book_types')
          .where('name', isEqualTo: type)
          .get()
          .then((docType) {
        db
            .collection('b_has_bt')
            .where('book', isEqualTo: idBook)
            .where('type', isEqualTo: docType.docs[0].id)
            .get()
            .then((value) {
          db.collection('b_has_bt').doc(value.docs[0].id).delete();
        });
      });
    }
    linkTypeAndBook(idBook, newTypes);
  }

  Future<List<Map<String, dynamic>?>> getAllBookInLibrary(String accType) async {
    final db = FirebaseFirestore.instance;
    List<Map<String, dynamic>?> output = [];

    if (accType == "ADMIN") {
      await db
          .collection('books')
          .where('approveStatus', isEqualTo: true)
          .get()
          .then((querySnapshot) {
        for (var docSnap in querySnapshot.docs) {
          var data = docSnap.data();
          data['createDateTime'] = data['updateDateTime'];
          output.add(data);
        }
      });
    } else {
      final user = FirebaseAuth.instance.currentUser;
      await db
          .collection('a_has_b')
          .where('account', isEqualTo: user!.uid)
          .get()
          .then((querySnapshot) async {
        for (var docSnap in querySnapshot.docs) {
          var idSplit = docSnap.data()['book'].split("_");
          if (!await SaleController().checkHasSale(idSplit[0], idSplit[1]))
            await db
                .collection('books')
                .doc(docSnap.data()['book'])
                .get()
                .then((value) {
              var data = value.data();
              data!['createDateTime'] = docSnap.data()['createDateTime'];
              output.add(data);
            });
        }
      });
    }
    output.sort((a, b) => b!['createDateTime'].compareTo(a!['createDateTime']));
    return output;
  }

  Future<List<Map<String, dynamic>?>> getAllBookPendingApproval() async {
    final db = FirebaseFirestore.instance;
    List<Map<String, dynamic>?> output = [];

    await db
        .collection('books')
        .where('approveStatus', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      for (var docSnap in querySnapshot.docs) {
        output.add(docSnap.data());
      }
    });

    return output;
  }
}

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageController {
  Future<String> uploadToFireStorage(File file, String fileName) async {
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef.child(fileName + ".png");

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
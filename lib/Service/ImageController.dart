import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageController {
  final storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadToFireStorage(File file) async {
    final user = FirebaseAuth.instance.currentUser;
    Reference ref = storageRef.child(user!.uid + ".png");

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
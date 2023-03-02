import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_book/Screen/LogInPage.dart';

class AccountController {
  Future<void> register(String username, String password, String name, String address, String phone) async {
    await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: username + "@mybook.com", password: password)
      .then((value) => postAccountDetails(username, name, address, phone));
  }

  void postAccountDetails(String username, String name, String address, String phone) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final data = {
      "username" : username,
      "type" : "USER",
      "name" : name,
      "address" : address,
      "phone" : phone,
      "image" : "gs://mybook-f9b37.appspot.com/defaultProfilePic.svg"
    };

    db.collection('accounts').doc(user!.uid).set(data);
  }

  Future<void> login(String username, String password) async {
    await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: username + "@mybook.com", password: password);
  }

  Future<void> logout() async {
    FirebaseAuth.instance
      .signOut();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(email: user?.email ?? "", password: currentPassword);

    await user?.reauthenticateWithCredential(cred)
      .then((value) async {
        await user.updatePassword(newPassword);
      });
  }
}
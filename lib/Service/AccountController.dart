import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_book/Screen/LogInPage.dart';

class AccountController {
  Future<void> register(String username, String password, String name, String address, String phone) async {
    String email = username + "@mybook.com";
    await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((value) => postAccountDetails(username, name, address, phone));
  }

  void postAccountDetails(String username, String name, String address, String phone) async {
    var db = FirebaseFirestore.instance;
    var user = FirebaseAuth.instance.currentUser;
    final data = {
      "username" : username,
      "type" : "USER",
      "name" : (name == "") ? username : name,
      "address" : address,
      "phone" : phone,
      "image" : "gs://mybook-f9b37.appspot.com/defaultProfilePic.svg"
    };

    db.collection('accounts').doc(user!.uid).set(data);
  }
}
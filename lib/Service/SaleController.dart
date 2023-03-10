import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_book/Service/ImageController.dart';

class SaleController {
  Future<void> addSale(String idBook, String detail, String sellingPrice, String deliveryFee, String bank, String bankAccountNumber, File image) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    String downloadURL = await ImageController().uploadToFireStorage(image, "${idBook}_${user!.uid}");
    final data = {
      "detail": detail,
      "sellingPrice": int.parse(sellingPrice),
      "deliveryFee": int.parse(deliveryFee),
      "bank": bank,
      "bankAccountNumber": bankAccountNumber,
      "image": downloadURL,
      "seller": user.uid,
      "saleStatus": "N",
      "createDateTime": Timestamp.now(),
      "updateDateTime": "",
      "buyer": "",
      "paymentSlip": "",
    };

    await db.collection('sales').add(data);
  }
}
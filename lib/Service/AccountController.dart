import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    user.updateDisplayName(username);
    user.updatePhotoURL("gs://mybook-f9b37.appspot.com/defaultProfilePic.svg");
  }

  Future<String> login(String username, String password) async {
    await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: username + "@mybook.com", password: password);
    
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final docSnap = await db.collection('accounts').doc(user!.uid).get();
    return docSnap.data()!['type'];
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

  Future<Map<String, dynamic>> getDeliveryInformation() async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    final docSnap = await db.collection('accounts').doc(user!.uid).get();
    final data = docSnap.data();
    return {
      "name": data!['name'],
      "address": data['address'],
      "phone": data['phone']
    };
  }

  Future<void> updateDeliveryInformation(Map<String, dynamic> data) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    
    await db.collection('accounts').doc(user!.uid)
      .update({
        "name": data['name'],
        "address": data['address'],
        "phone": data['phone']
      });
  }
}
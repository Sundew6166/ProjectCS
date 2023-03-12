import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:my_book/Service/AccountController.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  File? _image;

  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        print(_image);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('คุณยังไม่ได้เลือกรูป')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขโปร์ไฟล์'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: Container(
                        child: _image != null
                            ? Image.file(_image!, fit: BoxFit.cover)
                            : Image.network(user!.photoURL.toString()),
                      )),
                  Center(
                    child: ElevatedButton(
                      onPressed: _openImagePicker,
                      child: const Text('เลือกรูป'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_image != null) {
                              try {
                                await AccountController()
                                    .updateProfilePic(_image!)
                                    .then((value) => showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text("เสร็จสิ้น"),
                                              content: const Text(
                                                  'การแก้ไขโปรไฟล์ของคุณเสร็จสิ้น'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                        ..pop()
                                                        ..pop(),
                                                  child: const Text('ตกลง'),
                                                ),
                                              ],
                                            )));
                              } on FirebaseException catch (e) {
                                print(e.code);
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                            title: Text(e.message.toString()),
                                            content: const Text(
                                                "เกิดข้อผิดพลาดในการแก้ไขโปรไฟล์ กรุณาลองใหม่"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('ตกลง'),
                                              )
                                            ]));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('คุณยังไม่ได้เลือกรูป')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(400, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                10,
                              ))),
                          child: const Text("บันทึก",
                              style: TextStyle(fontSize: 20)))),
                ],
              ))),
    );
  }
}

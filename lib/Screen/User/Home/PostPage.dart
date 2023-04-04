import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:my_book/Screen/BottomBar.dart';

import 'package:my_book/Service/AccountController.dart';
import 'package:my_book/Service/PostController.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  static final _keyValidationForm = GlobalKey<FormState>();
  TextEditingController textarea = TextEditingController();
  final FocusNode _unUsedFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('สร้างโพสต์'),
        ),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _keyValidationForm,
              child: Column(
                children: [
                  TextFormField(
                    onTapOutside: (PointerDownEvent event) {
                      FocusScope.of(context).requestFocus(_unUsedFocusNode);
                    },
                    controller: textarea,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLines: 8,
                    validator: (value) {
                      return value!.isEmpty ? 'ข้อมูลไม่ถูกต้อง' : null;
                    },
                    decoration: const InputDecoration(
                        hintText: "พิมพ์ข้อความลงในนี้...",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Color(0xff795e35)))),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_keyValidationForm.currentState!.validate()) {
                          String accT =
                              await AccountController().getAccountType();
                          try {
                            await PostController()
                                .addPost(textarea.text)
                                .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BottomBar(
                                          accType: accT,
                                          tab: "HOME",
                                        ),
                                      ),
                                    ));
                          } on FirebaseException catch (e) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                        title: Text(e.message.toString()),
                                        content: const Text(
                                            "เกิดข้อผิดพลาดในการส่งข้อมูล กรุณาลองใหม่"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('ตกลง'),
                                          )
                                        ]));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(400, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child:
                          const Text("โพสต์", style: TextStyle(fontSize: 20)))
                ],
              ),
            )));
  }
}

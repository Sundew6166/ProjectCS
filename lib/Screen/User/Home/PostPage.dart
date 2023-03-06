import 'package:flutter/material.dart';
import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Service/AccountController.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  static var _keyValidationForm = GlobalKey<FormState>();
  TextEditingController textarea = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('สร้างโพสต์'),
        ),
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Form(
              key: _keyValidationForm,
              child: Column(
                children: [
                  TextFormField(
                    controller: textarea,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    validator: (value) {
                      return value!.isEmpty ? 'ข้อมูลไม่ถูกต้อง' : null;
                    },
                    decoration: InputDecoration(
                        hintText: "พิมพ์ข้อความลงในนี้...",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: const Color(0xff795e35)))),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_keyValidationForm.currentState!.validate()) {
                          String accT =
                              await AccountController().getAccountType();
                          // print(accT);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomBar(
                                      accType: accT,
                                    )),
                          );
                          // print(textarea.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(400, 40), // specify width, height
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                            10,
                          ))),
                      child: Text("โพสต์", style: TextStyle(fontSize: 20)))
                ],
              ),
            )));
  }
}

import 'package:flutter/material.dart';

class EditPasswordPage extends StatelessWidget {
  TextEditingController _textEditCurPassword = TextEditingController();
  TextEditingController _textEditConPassword = TextEditingController();
  TextEditingController _textEditConConfirmPassword = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    isPasswordVisible = false;
    isConfirmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('เปลี่ยนรหัสผ่าน'),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
            ),
            Container(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _textEditCurPassword,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              obscureText: !isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "รหัสผ่านปัจจุบัน",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _textEditConPassword,
                              decoration: InputDecoration(
                                hintText: "รหัสผ่านใหม่",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _textEditConConfirmPassword,
                              decoration: InputDecoration(
                                hintText: "ยืนยันรหัสผ่านใหม่",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                print(_textEditCurPassword.text);
                                print(_textEditConPassword.text);
                                print(_textEditConConfirmPassword.text);
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize:
                                      Size(400, 40), // specify width, height
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                    10,
                                  ))),
                              child: Text("เปลี่ยนรหัสผ่าน",
                                  style: TextStyle(fontSize: 20)))
                        ],
                      ))
                    ],
                  ),
                )),
          ],
        ));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:my_book/Screen/RegisterPage.dart';
import 'package:my_book/Screen/BottomBar.dart';

import '../Service/AccountController.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  static final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _textEditUsername = TextEditingController();
  final TextEditingController _textEditPassword = TextEditingController();
  bool isPasswordVisible = false;
  String? _errorFromFirebase;

  @override
  void initState() {
    isPasswordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff795e35),
        body: SingleChildScrollView(
          child: WillPopScope(
            onWillPop: () async => false,
            child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(
                  children: <Widget>[
                    getWidgetImageLogo(),
                    getWidgetRegistrationCard(),
                  ],
                )),
          ),
        ));
  }

  Widget getWidgetImageLogo() {
    return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: Image.asset(
            "images/logo.PNG",
            height: 100,
          ),
        ));
  }

  Widget getWidgetRegistrationCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: const Text('เข้าสู่ระบบ'),
                ),
                TextFormField(
                  controller: _textEditUsername,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator:
                      RequiredValidator(errorText: "กรุณากรอกชื่อผู้ใช้"),
                  decoration: const InputDecoration(
                      labelText: 'ชื่อผู้ใช้', icon: Icon(Icons.person)),
                ),
                TextFormField(
                  controller: _textEditPassword,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: RequiredValidator(errorText: "กรุณากรอกรหัสผ่าน"),
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      icon: const Icon(Icons.vpn_key)),
                ),
                Text(
                    _errorFromFirebase == null
                        ? ""
                        : _errorFromFirebase.toString(),
                    style: const TextStyle(color: Color(0xFFFF0000))),
                Container(
                    margin: const EdgeInsets.only(top: 32.0),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _errorFromFirebase = null;
                          });
                          if (_loginFormKey.currentState!.validate()) {
                            try {
                              await AccountController()
                                  .login(_textEditUsername.text,
                                      _textEditPassword.text)
                                  .then((value) {
                                print("type: " + value);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BottomBar(
                                              accType: value,
                                              tab: "HOME",
                                            )));
                              });
                            } on FirebaseAuthException catch (e) {
                              print(e.code);
                              setState(() {
                                _errorFromFirebase =
                                    "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง";
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(400, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                              10,
                            ))),
                        child: const Text("เข้าสู่ระบบ",
                            style: TextStyle(fontSize: 20)))),
                Container(
                    margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          splashColor: const Color(0xff795e35).withOpacity(0.5),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          ),
                          child: const Text(' ลงทะเบียน',
                              style: TextStyle(
                                  color: Color(0xff795e35),
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

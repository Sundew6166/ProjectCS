import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../auth.dart';
// import 'package:my_book/main.dart';
import 'package:my_book/Screen/RegisterPage.dart';
import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Screen/User/Home/HomePage.dart';

import '../Service/AccountController.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  static var _loginFormKey = GlobalKey<FormState>();
  TextEditingController _textEditUsername = TextEditingController();
  TextEditingController _textEditPassword = TextEditingController();
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
          child: new WillPopScope(
            onWillPop: () async => false,
            child: Padding(
                padding: EdgeInsets.only(top: 32.0),
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
                  child: Text(
                    'เข้าสู่ระบบ',
                  ),
                ), // title: login
                Container(
                  child: TextFormField(
                    controller: _textEditUsername,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: RequiredValidator(errorText: "กรุณากรอกชื่อผู้ใช้"),
                    // onFieldSubmitted: (String value) {
                    //   FocusScope.of(context).requestFocus(_passwordEmail);
                    // },
                    decoration: InputDecoration(
                        labelText: 'ชื่อผู้ใช้',
                        //prefixIcon: Icon(Icons.email),
                        icon: Icon(Icons.person)),
                  ),
                ), //text field : user name //text field: email
                Container(
                  child: TextFormField(
                    controller: _textEditPassword,
                    // focusNode: _passwordFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: RequiredValidator(errorText: "กรุณากรอกรหัสผ่าน"),
                    // onFieldSubmitted: (String value) {
                    //   FocusScope.of(context)
                    //       .requestFocus(_passwordConfirmFocus);
                    // },
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
                        icon: Icon(Icons.vpn_key)),
                  ),
                ), //text field: password
                Text(
                  _errorFromFirebase == null ? "" : _errorFromFirebase.toString(),
                  style: TextStyle(color: Color(0xFFFF0000)),
                ),
                Container(
                    margin: EdgeInsets.only(top: 32.0),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async{
                          setState(() {
                            _errorFromFirebase = null;
                          });
                          if (_loginFormKey.currentState!.validate()) {
                            try {
                              await AccountController().login(_textEditUsername.text, _textEditPassword.text)
                                .then((value) {
                                  print("type: " + value);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar()));
                                });
                            } on FirebaseAuthException catch (e) {
                              print(e.code);
                              setState(() {
                                _errorFromFirebase = "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง";
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(400, 40), // specify width, height
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                              10,
                            ))),
                        child: Text("เข้าสู่ระบบ",
                            style: TextStyle(fontSize: 20)))), //button: login
                Container(
                    margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          splashColor: const Color(0xff795e35).withOpacity(0.5),
                          // onTap: () {
                          //   _onTappedTextlogin();
                          // },
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          ),
                          child: Text(
                            ' ลงทะเบียน',
                            style: TextStyle(
                                color: const Color(0xff795e35),
                                fontWeight: FontWeight.bold),
                          ),
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

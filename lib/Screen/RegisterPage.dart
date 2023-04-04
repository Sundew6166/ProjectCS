import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Screen/LogInPage.dart';

import 'package:my_book/Service/AccountController.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _textEditName = TextEditingController();
  final TextEditingController _textEditUsername = TextEditingController();
  final TextEditingController _textEditPassword = TextEditingController();
  final TextEditingController _textEditConfirmPassword =
      TextEditingController();
  final TextEditingController _textEditPhone = TextEditingController();
  final TextEditingController _textEditAddress = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String? _errorFromFirebase;
  final FocusNode _unUsedFocusNode = FocusNode();

  @override
  void initState() {
    isPasswordVisible = false;
    isConfirmPasswordVisible = false;
    super.initState();
  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: Center(child: Text("${snapshot.error}")),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }

  Widget getWidgetImageLogo() {
    return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: Image.asset("images/logo.PNG", height: 100),
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
            key: _registerFormKey,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: const Text('ลงทะเบียน'),
                ),
                TextFormField(
                  onTapOutside: (PointerDownEvent event) {
                    FocusScope.of(context).requestFocus(_unUsedFocusNode);
                  },
                  controller: _textEditUsername,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator:
                      RequiredValidator(errorText: "กรุณากรอกชื่อผู้ใช้"),
                  decoration: InputDecoration(
                      labelText: 'ชื่อผู้ใช้',
                      icon: const Icon(Icons.person),
                      errorText: _errorFromFirebase),
                ),
                TextFormField(
                  onTapOutside: (PointerDownEvent event) {
                    FocusScope.of(context).requestFocus(_unUsedFocusNode);
                  },
                  controller: _textEditPassword,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: MinLengthValidator(8,
                      errorText: "รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร"),
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
                TextFormField(
                    onTapOutside: (PointerDownEvent event) {
                      FocusScope.of(context).requestFocus(_unUsedFocusNode);
                    },
                    controller: _textEditConfirmPassword,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        MatchValidator(errorText: "รหัสผ่านไม่ตรงกัน")
                            .validateMatch(value ?? "", _textEditPassword.text),
                    obscureText: !isConfirmPasswordVisible,
                    decoration: InputDecoration(
                        labelText: 'ยืนยันรหัสผ่าน',
                        suffixIcon: IconButton(
                          icon: Icon(isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                            });
                          },
                        ),
                        icon: const Icon(Icons.vpn_key))),
                TextFormField(
                  onTapOutside: (PointerDownEvent event) {
                    FocusScope.of(context).requestFocus(_unUsedFocusNode);
                  },
                  controller: _textEditName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      labelText: 'ชื่อ สกุล (ข้อมูลการจัดส่ง)',
                      icon: Icon(Icons.text_fields_outlined)),
                ),
                TextFormField(
                  onTapOutside: (PointerDownEvent event) {
                    FocusScope.of(context).requestFocus(_unUsedFocusNode);
                  },
                  controller: _textEditAddress,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      labelText: 'ที่อยู่ (ข้อมูลการจัดส่ง)',
                      icon: Icon(Icons.home)),
                ),
                TextFormField(
                  onTapOutside: (PointerDownEvent event) {
                    FocusScope.of(context).requestFocus(_unUsedFocusNode);
                  },
                  controller: _textEditPhone,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                      labelText: 'เบอร์โทรศัพท์ (ข้อมูลการจัดส่ง)',
                      icon: Icon(Icons.phone)),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 32.0),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _errorFromFirebase = null;
                          });
                          if (_registerFormKey.currentState!.validate()) {
                            try {
                              await AccountController()
                                  .register(
                                      _textEditUsername.text,
                                      _textEditPassword.text,
                                      _textEditName.text,
                                      _textEditAddress.text,
                                      _textEditPhone.text)
                                  .then((value) => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BottomBar(
                                              accType: 'USER', tab: "HOME"))));
                            } on FirebaseAuthException catch (e) {
                              print(e.code);
                              setState(() {
                                if (e.code == 'email-already-in-use') {
                                  _errorFromFirebase =
                                      "ชื่อผู้ใช้นี้ถูกใช้ไปแล้ว";
                                } else {
                                  _errorFromFirebase = e.message;
                                }
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
                        child: const Text("ลงทะเบียน",
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
                                builder: (context) => const LogInPage()),
                          ),
                          child: const Text('เข้าสู่ระบบ',
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

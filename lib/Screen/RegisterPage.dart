import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Screen/LogInPage.dart';
import 'package:my_book/Service/AccountController.dart';
// import 'package:thought_factory/utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static var _registerFormKey = GlobalKey<FormState>();
  TextEditingController _textEditName = TextEditingController();
  TextEditingController _textEditUsername = TextEditingController();
  TextEditingController _textEditPassword = TextEditingController();
  TextEditingController _textEditConfirmPassword = TextEditingController();
  TextEditingController _textEditPhone = TextEditingController();
  TextEditingController _textEditAddress = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String? _errorFromFirebase;

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
              appBar: AppBar(title: Text("Error")),
              body: Center(child: Text("${snapshot.error}")),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
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
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
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
    // final FocusNode _passwordEmail = FocusNode();
    // final FocusNode _passwordFocus = FocusNode();
    // final FocusNode _passwordConfirmFocus = FocusNode();

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
                  child: Text(
                    'ลงทะเบียน',
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
                        icon: Icon(Icons.person),
                        errorText: _errorFromFirebase
                    ),
                  ),
                ), //text field : user name //text field: email
                Container(
                  child: TextFormField(
                    controller: _textEditPassword,
                    // focusNode: _passwordFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: MinLengthValidator(8, errorText: "รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร"),
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
                Container(
                  child: TextFormField(
                      controller: _textEditConfirmPassword,
                      // focusNode: _passwordConfirmFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (value) => MatchValidator(errorText: "รหัสผ่านไม่ตรงกัน").validateMatch(value ?? "", _textEditPassword.text),
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
                          icon: Icon(Icons.vpn_key))),
                ),
                Container(
                  child: TextFormField(
                    controller: _textEditName,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    // validator: _validateUserName,
                    // onFieldSubmitted: (String value) {
                    //   FocusScope.of(context).requestFocus(_passwordEmail);
                    // },
                    decoration: InputDecoration(
                        labelText: 'ชื่อ สกุล (ข้อมูลการจัดส่ง)',
                        //prefixIcon: Icon(Icons.email),
                        icon: Icon(Icons.text_fields_outlined)),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: _textEditAddress,
                    // focusNode: _passwordEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    // validator: _validateEmail,
                    // onFieldSubmitted: (String value) {
                    //   FocusScope.of(context).requestFocus(_passwordFocus);
                    // },
                    decoration: InputDecoration(
                        labelText: 'ที่อยู่ (ข้อมูลการจัดส่ง)',
                        // prefixIcon: Icon(Icons.email),
                        icon: Icon(Icons.home)),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: _textEditPhone,
                    // focusNode: _passwordEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    // validator: _validateEmail,
                    // onFieldSubmitted: (String value) {
                    //   FocusScope.of(context).requestFocus(_passwordFocus);
                    // },
                    decoration: InputDecoration(
                        labelText: 'เบอร์โทรศัพท์ (ข้อมูลการจัดส่ง)',
                        //prefixIcon: Icon(Icons.email),
                        icon: Icon(Icons.phone)),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 32.0),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async{
                          setState(() {
                            _errorFromFirebase = null;
                          });
                          if (_registerFormKey.currentState!.validate()) {
                            try {
                              await AccountController().register(_textEditUsername.text, _textEditPassword.text, _textEditName.text, _textEditAddress.text, _textEditPhone.text)
                                .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(accType: 'USER',))));
                            } on FirebaseAuthException catch (e) {
                              print(e.code);
                              setState(() {
                                if(e.code == 'email-already-in-use'){
                                  _errorFromFirebase = "ชื่อผู้ใช้นี้ถูกใช้ไปแล้ว";
                                }else{
                                  _errorFromFirebase = e.message;
                                }
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
                        child: Text("ลงทะเบียน",
                            style: TextStyle(fontSize: 20)))), //button: login
                Container(
                    margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          splashColor: const Color(0xff795e35).withOpacity(0.5),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInPage()),
                          ),
                          child: Text(
                            'เข้าสู่ระบบ',
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

// String _validateUserName(String value) {
// return value.trim().isEmpty ? "Name can't be empty" : null;
// }

// String _validateEmail(String value) {
// Pattern pattern =
//     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
// RegExp regex = new RegExp(pattern);
// if (!regex.hasMatch(value)) {
//   return 'Invalid Email';
// } else {
//   return null;
// }
// }

// String _validatePassword(String value) {
// return value.length < 5 ? 'Min 5 char required' : null;
// }

// String _validateConfirmPassword(String value) {
// return value.length < 5 ? 'Min 5 char required' : null;
// }

  void _onTappedButtonRegister() {}

  void _onTappedTextlogin() {}
}

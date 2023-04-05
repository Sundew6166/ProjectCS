import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:my_book/Service/AccountController.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _changePasswordFormKey = GlobalKey<FormState>();

  final TextEditingController _textEditCurPassword = TextEditingController();
  final TextEditingController _textEditConPassword = TextEditingController();
  final TextEditingController _textEditConConfirmPassword =
      TextEditingController();

  bool isCurPasswordVisible = false;
  bool isConPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final FocusNode _unUsedFocusNode = FocusNode();

  @override
  void initState() {
    isCurPasswordVisible = false;
    isConPasswordVisible = false;
    isConfirmPasswordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('เปลี่ยนรหัสผ่าน'),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Form(
                key: _changePasswordFormKey,
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      onTapOutside: (PointerDownEvent event) {
                                        FocusScope.of(context)
                                            .requestFocus(_unUsedFocusNode);
                                      },
                                      controller: _textEditCurPassword,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      obscureText: !isCurPasswordVisible,
                                      validator: MinLengthValidator(8,
                                          errorText:
                                              "รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร"),
                                      decoration: InputDecoration(
                                          labelText: 'รหัสผ่านปัจจุบัน',
                                          suffixIcon: IconButton(
                                            icon: Icon(isCurPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                isCurPasswordVisible =
                                                    !isCurPasswordVisible;
                                              });
                                            },
                                          ),
                                          icon: const Icon(Icons.vpn_key)),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      onTapOutside: (PointerDownEvent event) {
                                        FocusScope.of(context)
                                            .requestFocus(_unUsedFocusNode);
                                      },
                                      controller: _textEditConPassword,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      obscureText: !isConPasswordVisible,
                                      validator: MinLengthValidator(8,
                                          errorText:
                                              "รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร"),
                                      decoration: InputDecoration(
                                          labelText: 'รหัสผ่านใหม่',
                                          suffixIcon: IconButton(
                                            icon: Icon(isConPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                isConPasswordVisible =
                                                    !isConPasswordVisible;
                                              });
                                            },
                                          ),
                                          icon: const Icon(Icons.vpn_key)),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      onTapOutside: (PointerDownEvent event) {
                                        FocusScope.of(context)
                                            .requestFocus(_unUsedFocusNode);
                                      },
                                      controller: _textEditConConfirmPassword,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      obscureText: !isConfirmPasswordVisible,
                                      validator: (value) => MatchValidator(
                                              errorText: "รหัสผ่านไม่ตรงกัน")
                                          .validateMatch(value ?? "",
                                              _textEditConPassword.text),
                                      decoration: InputDecoration(
                                          labelText: 'ยืนยันรหัสผ่านใหม่',
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
                                          icon: const Icon(Icons.vpn_key)),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 16.0, bottom: 16.0),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (_changePasswordFormKey
                                                .currentState!
                                                .validate()) {
                                              try {
                                                await AccountController()
                                                    .changePassword(
                                                        _textEditCurPassword
                                                            .text,
                                                        _textEditConPassword
                                                            .text)
                                                    .then((value) => showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            AlertDialog(
                                                                title: const Text(
                                                                    "เสร็จสิ้น"),
                                                                content: const Text(
                                                                    'การเปลี่ยนรหัสผ่านของคุณเสร็จสิ้น'),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                      onPressed: () => Navigator.of(
                                                                          context)
                                                                        ..pop()
                                                                        ..pop(),
                                                                      child: const Text(
                                                                          'ตกลง'))
                                                                ])));
                                              } on FirebaseAuthException catch (e) {
                                                print(e.code);
                                                String? message;
                                                if (e.code ==
                                                    'wrong-password') {
                                                  message =
                                                      "รหัสผ่านปัจจุบันไม่ถูกต้อง";
                                                } else {
                                                  message = e.message;
                                                }
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                            title: Text(message
                                                                .toString()),
                                                            content: const Text(
                                                                "เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน กรุณาลองใหม่"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child:
                                                                      const Text(
                                                                          'ตกลง'))
                                                            ]));
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(400, 40),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                10,
                                              ))),
                                          child: const Text("บันทึก",
                                              style: TextStyle(fontSize: 20))))
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                ))));
  }
}

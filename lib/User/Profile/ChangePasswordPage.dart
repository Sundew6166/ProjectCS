import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  static var _keyValidationForm = GlobalKey<FormState>();

  TextEditingController _textEditCurPassword = TextEditingController();
  TextEditingController _textEditConPassword = TextEditingController();
  TextEditingController _textEditConConfirmPassword = TextEditingController();

  bool isCurPasswordVisible = false;
  bool isConPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

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
                key: _keyValidationForm,
                child: Column(
                  children: [
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
                                  // รหัสผ่านปัจจุบัน
                                  Container(
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      controller: _textEditCurPassword,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      obscureText: !isCurPasswordVisible,
                                      validator: (value) {
                                        return value!.length < 8
                                            ? 'ใส่รหัสผ่านอย่างน้อย 8 ตัว'
                                            : null;
                                      },
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
                                          icon: Icon(Icons.vpn_key)),
                                    ),
                                  ),
                                  // รหัสผ่านใหม่
                                  Container(
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      controller: _textEditConPassword,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      obscureText: !isConPasswordVisible,
                                      validator: (value) {
                                        return value!.length < 8
                                            ? 'ใส่รหัสผ่านอย่างน้อย 8 ตัว'
                                            : null;
                                      },
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
                                          icon: Icon(Icons.vpn_key)),
                                    ),
                                  ),
                                  // ยืนยันรหัสผ่านใหม่
                                  Container(
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      controller: _textEditConConfirmPassword,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      obscureText: !isConfirmPasswordVisible,
                                      validator: (value) {
                                        return value!.length < 8
                                            ? 'ใส่รหัสผ่านอย่างน้อย 8 ตัว'
                                            : null;
                                      },
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
                                          icon: Icon(Icons.vpn_key)),
                                    ),
                                  ),
                                  // button
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 16.0, bottom: 16.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (_keyValidationForm.currentState!
                                                .validate()) {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        title: const Text(
                                                            "เสร็จสิ้น"),
                                                        content: Text(
                                                            'การเปลี่ยนรหัสผ่านของคุณเสร็จสิ้น'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'ตกลง'),
                                                            child: const Text(
                                                                'ตกลง'),
                                                          ),
                                                        ],
                                                      ));
                                              _keyValidationForm.currentState
                                                  ?.reset();
                                            }
                                            // print(_textEditCurPassword.text);
                                            // print(_textEditConPassword.text);
                                            // print(_textEditConConfirmPassword.text);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: Size(400,
                                                  40), // specify width, height
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                10,
                                              ))),
                                          child: Text("บันทึก",
                                              style: TextStyle(fontSize: 20))))
                                ],
                              ))
                            ],
                          ),
                        )),
                  ],
                ))));
  }
}

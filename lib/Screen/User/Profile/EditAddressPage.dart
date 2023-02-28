import 'package:flutter/material.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  static var _addressValidationForm = GlobalKey<FormState>();

  TextEditingController _textEditName = TextEditingController();
  TextEditingController _textEditPhone = TextEditingController();
  TextEditingController _textEditAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('แก้ไขข้อมูลการจัดส่ง'),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Form(
                key: _addressValidationForm,
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
                                  Container(
                                    margin: const EdgeInsets.only(left: 15),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: _textEditName,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        return value!.trim().isEmpty
                                            ? "กรอกชื่อ สกุลไม่ถูกต้อง"
                                            : null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'ชื่อ สกุล',
                                          icon:
                                              Icon(Icons.text_fields_outlined)),
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: _textEditPhone,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        return (value!.isNotEmpty && value.length != 10)
                                            ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                            : null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'เบอร์โทรศัพท์',
                                          icon: Icon(Icons.phone)),
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: _textEditAddress,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                          labelText: 'ที่อยู่',
                                          icon: Icon(Icons.home)),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 16.0, bottom: 16.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (_addressValidationForm
                                                .currentState!
                                                .validate()) {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        title: const Text(
                                                            "เสร็จสิ้น"),
                                                        content: Text(
                                                            'การแก้ไขข้อมูลการจัดส่งของคุณเสร็จสิ้น'),
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
                                              // _addressValidationForm
                                              //     .currentState
                                              //     ?.reset();
                                            }
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
                                              style: TextStyle(
                                                  fontSize:
                                                      20)))), //button: login
                                ],
                              ))
                            ],
                          ),
                        )),
                  ],
                ))));
  }
}

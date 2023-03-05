import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_book/Service/AccountController.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key, required this.deliInfo});
  final Map<String, dynamic> deliInfo;

  @override
  State<EditAddressPage> createState() => _EditAddressPageState(this.deliInfo);
}

class _EditAddressPageState extends State<EditAddressPage> {
  Map<String, dynamic> deliInfo;
  _EditAddressPageState(this.deliInfo);

  static var _addressFormKey = GlobalKey<FormState>();

  TextEditingController _textEditName = TextEditingController();
  TextEditingController _textEditAddress = TextEditingController();
  TextEditingController _textEditPhone = TextEditingController();

  @override
  void initState() {
    _textEditName.text = deliInfo['name'];
    _textEditAddress.text = deliInfo['address'];
    _textEditPhone.text = deliInfo['phone'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return WillPopScope(
        onWillPop: () async {
          return shouldPop;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('แก้ไขข้อมูลการจัดส่ง'),
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: Form(
                    key: _addressFormKey,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 15),
                                      ),
                                      Container(
                                        child: TextFormField(
                                          controller: _textEditName,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          // validator: RequiredValidator(errorText: "กรุณากรอกชื่อสำหรับจัดส่ง"),
                                          decoration: InputDecoration(
                                              labelText: 'ชื่อ สกุล',
                                              icon: Icon(
                                                  Icons.text_fields_outlined)),
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
                                        child: TextFormField(
                                          controller: _textEditPhone,
                                          keyboardType: TextInputType.phone,
                                          textInputAction: TextInputAction.next,
                                          validator: (value) {
                                            return (value!.isNotEmpty &&
                                                    value.length != 10)
                                                ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                                : null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'เบอร์โทรศัพท์',
                                              icon: Icon(Icons.phone)),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 16.0, bottom: 16.0),
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                if (_addressFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  try {
                                                    await AccountController()
                                                        .updateDeliveryInformation({
                                                      "name":
                                                          _textEditName.text,
                                                      "address":
                                                          _textEditAddress.text,
                                                      "phone":
                                                          _textEditPhone.text
                                                    })
                                                    // .then((value) =>
                                                    //         Navigator.pop(context));
                                                    .then((value) => showDialog(
                                                      context: context,
                                                      builder: (_) => AlertDialog(
                                                        title: const Text("เสร็จสิ้น"),
                                                        content: Text('การแก้ไขข้อมูลการจัดส่งของคุณเสร็จสิ้น'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(context)..pop()..pop(),
                                                            child: const Text('ตกลง'),
                                                          ),
                                                        ],
                                                      )),
                                                    );
                                                  } on FirebaseException catch (e) {
                                                    print(e.code);
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            AlertDialog(
                                                                title: Text(e
                                                                    .message
                                                                    .toString()),
                                                                content: Text(
                                                                    "เกิดข้อผิดพลาดในการแก้ไขข้อมูลการจัดส่ง กรุณาลองใหม่"),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child: const Text(
                                                                        'ตกลง'),
                                                                  )
                                                                ]));
                                                  }
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
                    )))));
  }
}

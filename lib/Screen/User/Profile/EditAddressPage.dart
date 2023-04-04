import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_book/Service/AccountController.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  static final _addressFormKey = GlobalKey<FormState>();

  final TextEditingController _textEditName = TextEditingController();
  final TextEditingController _textEditAddress = TextEditingController();
  final TextEditingController _textEditPhone = TextEditingController();
  final FocusNode _unUsedFocusNode = FocusNode();

  @override
  void initState() {
    setInitForm();
    super.initState();
  }

  setInitForm() async {
    await AccountController().getDeliveryInformation().then((value) {
      setState(() {
        _textEditName.text = value['name'];
        _textEditAddress.text = value['address'];
        _textEditPhone.text = value['phone'];
      });
    });
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 15),
                                      ),
                                      TextFormField(
                                        onTapOutside: (PointerDownEvent event) {
                                          FocusScope.of(context)
                                              .requestFocus(_unUsedFocusNode);
                                        },
                                        controller: _textEditName,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                            labelText: 'ชื่อ สกุล',
                                            icon: Icon(
                                                Icons.text_fields_outlined)),
                                      ),
                                      TextFormField(
                                        onTapOutside: (PointerDownEvent event) {
                                          FocusScope.of(context)
                                              .requestFocus(_unUsedFocusNode);
                                        },
                                        controller: _textEditAddress,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                            labelText: 'ที่อยู่',
                                            icon: Icon(Icons.home)),
                                      ),
                                      TextFormField(
                                        onTapOutside: (PointerDownEvent event) {
                                          FocusScope.of(context)
                                              .requestFocus(_unUsedFocusNode);
                                        },
                                        controller: _textEditPhone,
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.done,
                                        validator: (value) {
                                          return (value!.isNotEmpty &&
                                                  value.length != 10)
                                              ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                              : null;
                                        },
                                        decoration: const InputDecoration(
                                            labelText: 'เบอร์โทรศัพท์',
                                            icon: Icon(Icons.phone)),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
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
                                                    }).then(
                                                      (value) => showDialog(
                                                          context: context,
                                                          builder:
                                                              (_) =>
                                                                  AlertDialog(
                                                                    title: const Text(
                                                                        "เสร็จสิ้น"),
                                                                    content:
                                                                        const Text(
                                                                            'การแก้ไขข้อมูลการจัดส่งของคุณเสร็จสิ้น'),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                          onPressed: () => Navigator.of(
                                                                              context)
                                                                            ..pop()
                                                                            ..pop(),
                                                                          child:
                                                                              const Text('ตกลง')),
                                                                    ],
                                                                  )),
                                                    );
                                                  } on FirebaseException catch (e) {
                                                    print(e.code);
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) => AlertDialog(
                                                                title: Text(e
                                                                    .message
                                                                    .toString()),
                                                                content: const Text(
                                                                    "เกิดข้อผิดพลาดในการแก้ไขข้อมูลการจัดส่ง กรุณาลองใหม่"),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      child: const Text(
                                                                          'ตกลง'))
                                                                ]));
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(400, 40),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                    10,
                                                  ))),
                                              child: const Text("บันทึก",
                                                  style: TextStyle(
                                                      fontSize: 20)))),
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    )))));
  }
}

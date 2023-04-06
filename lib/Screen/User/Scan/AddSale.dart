import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Service/SaleController.dart';

class AddSale extends StatefulWidget {
  AddSale({super.key, required this.bookInfo});

  Map<String, dynamic> bookInfo;

  @override
  State<AddSale> createState() => _AddSaleState();
}

class _AddSaleState extends State<AddSale> {
  File? _image;

  final _picker = ImagePicker();
  final _addSaleFormKey = GlobalKey<FormState>();

  final TextEditingController _textISBN = TextEditingController();
  final TextEditingController _textTitle = TextEditingController();
  final TextEditingController _textPrice = TextEditingController();
  final TextEditingController _textEdition = TextEditingController();

  final TextEditingController _textDetail = TextEditingController();
  final TextEditingController _textSellingPrice = TextEditingController();
  final TextEditingController _textDeliveryFee = TextEditingController();
  final TextEditingController _textNameBankAccount = TextEditingController();
  final TextEditingController _textBankAccountNumber = TextEditingController();
  final FocusNode _unUsedFocusNode = FocusNode();

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        print(_image);
      });
    }
  }

  @override
  void initState() {
    _textISBN.text = widget.bookInfo['isbn'];
    _textTitle.text = widget.bookInfo['title'];
    _textPrice.text = widget.bookInfo['price'].toString();
    _textEdition.text = widget.bookInfo['edition'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ขาย'),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _addSaleFormKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 300,
                                  color: Colors.grey[300],
                                  child: Container(
                                    child: _image != null
                                        ? Image.file(_image!, fit: BoxFit.cover)
                                        : const Text('กรุณาเลือกรูป'),
                                  )),
                              Center(
                                child: ElevatedButton(
                                    onPressed: _openImagePicker,
                                    child: const Text('เลือกรูป')),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                              ),
                              TextFormField(
                                  enabled: false,
                                  controller: _textISBN,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration:
                                      const InputDecoration(labelText: 'ISBN')),
                              TextFormField(
                                enabled: false,
                                controller: _textTitle,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'ชื่อหนังสือ'),
                              ),
                              TextFormField(
                                enabled: false,
                                controller: _textPrice,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'ราคาตามปก'),
                              ),
                              TextFormField(
                                enabled: false,
                                controller: _textEdition,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'ครั้งที่พิมพ์'),
                              ),
                              TextFormField(
                                onTapOutside: (PointerDownEvent event) {
                                  FocusScope.of(context)
                                      .requestFocus(_unUsedFocusNode);
                                },
                                controller: _textDetail,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                    labelText: 'รายละเอียดสินค้า'),
                              ),
                              TextFormField(
                                onTapOutside: (PointerDownEvent event) {
                                  FocusScope.of(context)
                                      .requestFocus(_unUsedFocusNode);
                                },
                                controller: _textSellingPrice,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? "กรุณากรอกราคาที่จะขาย"
                                      : int.parse(value) > 0
                                          ? null
                                          : "ราคาขายต้องมากกว่า 0";
                                },
                                decoration:
                                    const InputDecoration(labelText: 'ราคาขาย'),
                              ),
                              TextFormField(
                                onTapOutside: (PointerDownEvent event) {
                                  FocusScope.of(context)
                                      .requestFocus(_unUsedFocusNode);
                                },
                                controller: _textDeliveryFee,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? "กรุณากรอกค่าส่ง"
                                      : int.parse(value) >= 0
                                          ? null
                                          : "ค่าส่งต้องไม่ติดลบ";
                                },
                                decoration:
                                    const InputDecoration(labelText: 'ค่าส่ง'),
                              ),
                              TextFormField(
                                onTapOutside: (PointerDownEvent event) {
                                  FocusScope.of(context)
                                      .requestFocus(_unUsedFocusNode);
                                },
                                controller: _textNameBankAccount,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: RequiredValidator(
                                    errorText: "กรุณากรอกชื่อธนาคาร"),
                                decoration:
                                    const InputDecoration(labelText: 'ธนาคาร'),
                              ),
                              TextFormField(
                                onTapOutside: (PointerDownEvent event) {
                                  FocusScope.of(context)
                                      .requestFocus(_unUsedFocusNode);
                                },
                                controller: _textBankAccountNumber,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                validator: RequiredValidator(
                                    errorText: "กรุณากรอกเลขบัญชีธนาคาร"),
                                decoration: const InputDecoration(
                                    labelText: 'เลขบัญชี'),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 16.0, bottom: 16.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_image == null) {
                                          showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                    title: const Text(
                                                        "กรุณาเพิ่มรูปสภาพหนังสือเล่มที่จะขาย"),
                                                    content: const Text(
                                                        "กรุณาเพิ่มรูปสภาพหนังสือเล่มที่จะขาย"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                              'ตกลง')),
                                                    ],
                                                  ));
                                        } else if (_addSaleFormKey.currentState!
                                            .validate()) {
                                          showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                    title: const Text(
                                                        "ยืนยันเพื่อเพิ่มไปยังการขาย"),
                                                    content: const Text(
                                                        'ยืนยันเพื่อเพิ่มไปยังการขาย'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            await SaleController()
                                                                .addSale(
                                                                    "${widget.bookInfo['isbn']}_${widget.bookInfo['edition']}",
                                                                    _textDetail
                                                                        .text,
                                                                    _textSellingPrice
                                                                        .text,
                                                                    _textDeliveryFee
                                                                        .text,
                                                                    _textNameBankAccount
                                                                        .text,
                                                                    _textBankAccountNumber
                                                                        .text,
                                                                    _image!)
                                                                .then((value) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) =>
                                                                      AlertDialog(
                                                                        title: const Text(
                                                                            "เสร็จสิ้น"),
                                                                        content:
                                                                            const Text("เพิ่มการขายหนังสือเสร็จสิ้น"),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => BottomBar(
                                                                                          accType: "USER",
                                                                                          tab: "PROFILE",
                                                                                        )),
                                                                              );
                                                                            },
                                                                            child:
                                                                                const Text('ตกลง'),
                                                                          ),
                                                                        ],
                                                                      ));
                                                            });
                                                          } on FirebaseException catch (e) {
                                                            print(e.code);
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    AlertDialog(
                                                                        title: Text(e
                                                                            .message
                                                                            .toString()),
                                                                        content:
                                                                            const Text(
                                                                                "เกิดข้อผิดพลาดในการทำงาน กรุณาลองใหม่"),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(context),
                                                                            child:
                                                                                const Text('ตกลง'),
                                                                          )
                                                                        ]));
                                                          }
                                                        },
                                                        child:
                                                            const Text('ตกลง'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'ยกเลิก'),
                                                        child: const Text(
                                                            'ยกเลิก'),
                                                      ),
                                                    ],
                                                  ));
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
                                          style: TextStyle(fontSize: 20)))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}

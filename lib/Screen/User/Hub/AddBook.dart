import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autocomplete_label/autocomplete_label.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/AccountController.dart';

class AddBook extends StatefulWidget {
  AddBook({Key? key, required this.isbn}) : super(key: key);

  String isbn;

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  static var _newBookFormKey = GlobalKey<FormState>();
  AutocompleteLabelController<String>? typeOption;

  TextEditingController _textISBN = TextEditingController();
  TextEditingController _textTitle = TextEditingController();
  TextEditingController _textAuthor = TextEditingController();
  TextEditingController _textPublisher = TextEditingController();
  TextEditingController _textPrice = TextEditingController();
  TextEditingController _textType = TextEditingController();
  TextEditingController _textSynopsys = TextEditingController();
  TextEditingController _textEdition = TextEditingController();

  @override
  void initState() {
    _textISBN.text = widget.isbn;
    _textEdition.text = "1";
    print(widget.isbn);
    setTypeOption();
    super.initState();
  }

  setTypeOption() async {
    await BookController().getBookTypes().then((value) {
      setState(() {
        typeOption = AutocompleteLabelController<String>(source: value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('หนังสือใหม่'),
        ),
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Form(
                key: _newBookFormKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
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
                                  // enabled: false,
                                  controller: _textISBN,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'ISBN',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textTitle,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: RequiredValidator(errorText: "กรุณากรอกชื่อหนังสือ"),
                                  decoration: InputDecoration(
                                    labelText: 'ชื่อหนังสือ',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textAuthor,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: RequiredValidator(errorText: "กรุณากรอกชื่อผู้แต่ง"),
                                  decoration: InputDecoration(
                                    labelText: 'ชื่อผู้แต่ง',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textPublisher,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: RequiredValidator(errorText: "กรุณากรอกชื่อสำนักพิมพ์"),
                                  decoration: InputDecoration(
                                    labelText: 'สำนักพิมพ์',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textEdition,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    return value!.isEmpty ? "กรุณากรอกครั้งที่พิมพ์" : int.parse(value) > 0 ? null : "ครั้งที่พิมพ์ต้องมากกว่า 0";
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'ครั้งที่พิมพ์',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textPrice,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    return value!.isEmpty ? "กรุณากรอกราคา" : int.parse(value) > 0 ? null : "ราคาต้องมากกว่า 0";
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'ราคาตามปก',
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text("ประเภท"),
                                  Expanded(
                                    child: AutocompleteLabel<String>(
                                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                        return ConstrainedBox(
                                          constraints: BoxConstraints(minWidth: 68),
                                          child: DryIntrinsicWidth(
                                            child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: TextField(
                                                strutStyle: StrutStyle(height: 1.0),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.zero,
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                  hintText: "เพิ่ม",
                                                ),
                                                controller: textEditingController,
                                                textInputAction: TextInputAction.next,
                                                onEditingComplete: onFieldSubmitted,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      autocompleteLabelController: typeOption,
                                    )
                                  )
                                ],
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textSynopsys,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: 'เรื่องย่อ',
                                  ),
                                ),
                              ),
                              Container(
                                  margin:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (_newBookFormKey.currentState!.validate()) {
                                          try {
                                            await BookController().addNewBookFromUser(_textISBN.text, _textTitle.text, _textAuthor.text, _textPublisher.text, int.parse(_textEdition.text), int.parse(_textPrice.text), typeOption!.values, _textSynopsys.text, null)
                                              .then((value) => showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text("รอการยืนยันจากผู้ดูแล"),
                                                  content: Text('ส่งข้อมูลเสร็จสิ้น รอการยืนยันจากผู้ดูแล'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () async {
                                                          String accT =
                                                              await AccountController()
                                                                  .getAccountType();
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BottomBar(
                                                                          accType:
                                                                              accT,
                                                                        )),
                                                          );
                                                        },
                                                        child:
                                                            const Text('ตกลง'),
                                                      ),
                                                    ],
                                                )
                                              ));
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
                                                            "เกิดข้อผิดพลาดในการส่งข้อมูล กรุณาลองใหม่"),
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
                                          fixedSize: Size(
                                              400, 40), // specify width, height
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                            10,
                                          ))),
                                      // TODO: if isApprove == false ปุ่มจะเขีบยว่า อนุมัติ
                                      // TODO: if isApprove == true ปุ่มจะเขีบยว่า บันทึก
                                      child: Text("บันทึก",
                                          style: TextStyle(
                                              fontSize: 20)))), //button: login
                            ],
                          ))
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}

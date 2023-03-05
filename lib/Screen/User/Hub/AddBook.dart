import 'package:flutter/material.dart';

import 'package:my_book/Screen/BottomBar.dart';

class AddBook extends StatefulWidget {
  AddBook({Key? key, required this.isbn}) : super(key: key);


  String isbn;

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  static var _addressValidationForm = GlobalKey<FormState>();

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
    super.initState();
    _textISBN = TextEditingController(text: widget.isbn);
    print(widget.isbn);
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
                key: _addressValidationForm,
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
                                  keyboardType: TextInputType.text,
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
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
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
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
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
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
                                  decoration: InputDecoration(
                                    labelText: 'สำนักพิมพ์',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textEdition,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
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
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
                                  decoration: InputDecoration(
                                    labelText: 'ราคาตามปก',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textType,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
                                  decoration: InputDecoration(
                                    labelText: 'ประเภทหนังสือ',
                                  ),
                                ),
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
                                      onPressed: () {
                                        if (_addressValidationForm.currentState!
                                            .validate()) {
                                          showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                    title: const Text(
                                                        "รอการยืนยันจากผู้ดูแล"),
                                                    content: Text(
                                                        'รอการยืนยันจากผู้ดูแล'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BottomBar()),
                                                        ),
                                                        child:
                                                            const Text('ตกลง'),
                                                      ),
                                                    ],
                                                  ));
                                          // _addressValidationForm
                                          //     .currentState
                                          //     ?.reset();
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autocomplete_label/autocomplete_label.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/AccountController.dart';

class AddBook extends StatefulWidget {
  AddBook({Key? key, required this.accType, this.isbn, this.bookInfo}) : super(key: key);

  String accType;
  Map<String,dynamic>? bookInfo;
  String? isbn;

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  static var _bookInfoFormKey = GlobalKey<FormState>();
  AutocompleteLabelController<String>? typeOption;
  File? _image;

  final _picker = ImagePicker();

  TextEditingController _textISBN = TextEditingController();
  TextEditingController _textTitle = TextEditingController();
  TextEditingController _textAuthor = TextEditingController();
  TextEditingController _textPublisher = TextEditingController();
  TextEditingController _textPrice = TextEditingController();
  TextEditingController _textSynopsys = TextEditingController();
  TextEditingController _textEdition = TextEditingController();

  @override
  void initState() {
    if (widget.bookInfo != null) {
      _textISBN.text = widget.bookInfo!['isbn'];
      _textTitle.text = widget.bookInfo!['title'];
      _textAuthor.text = widget.bookInfo!['author'];
      _textPublisher.text = widget.bookInfo!['publisher'];
      _textPrice.text = widget.bookInfo!['price'].toString();
      _textSynopsys.text = widget.bookInfo!['synopsys'];
      _textEdition.text = widget.bookInfo!['edition'].toString();
    } else if (widget.isbn != null) {
      _textISBN.text = widget.isbn!;
      _textEdition.text = "1";
    }
    setTypeOption();
    super.initState();
  }

  setTypeOption() async {
    await BookController().getBookTypes().then((value) {
      setState(() {
        typeOption = AutocompleteLabelController<String>(source: value);
        if (widget.bookInfo != null) {
          typeOption!.values.addAll(widget.bookInfo!['types']);
        }
      });
    });
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        print(_image);
      });
    }
    // else {
    // print("No image selected");
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(content: Text('คุณยังไม่ได้เลือกรูป')));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('หนังสือ'),
        ),
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Form(
                key: _bookInfoFormKey,
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
                              // แสดงรูป
                              Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 300,
                                  color: Colors.grey[300],
                                  child: Container(
                                    child: _image != null
                                        ? Image.file(_image!, fit: BoxFit.cover)
                                        : widget.bookInfo != null
                                        ? Image.network(widget.bookInfo!['coverImage'], fit: BoxFit.cover)
                                        : const Text('กรุณาเลือกรูป'),
                                  )),
                              // เลือกรูป
                              Center(
                                child: ElevatedButton(
                                  onPressed: _openImagePicker,
                                  child: const Text('เลือกรูป'),
                                ),
                              ),
                              // ISBN
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
                              // book name
                              Container(
                                child: TextFormField(
                                  controller: _textTitle,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: RequiredValidator(
                                      errorText: "กรุณากรอกชื่อหนังสือ"),
                                  decoration: InputDecoration(
                                    labelText: 'ชื่อหนังสือ',
                                  ),
                                ),
                              ),
                              // Author
                              Container(
                                child: TextFormField(
                                  controller: _textAuthor,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: RequiredValidator(
                                      errorText: "กรุณากรอกชื่อผู้แต่ง"),
                                  decoration: InputDecoration(
                                    labelText: 'ชื่อผู้แต่ง',
                                  ),
                                ),
                              ),
                              // Publisher
                              Container(
                                child: TextFormField(
                                  controller: _textPublisher,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: RequiredValidator(
                                      errorText: "กรุณากรอกชื่อสำนักพิมพ์"),
                                  decoration: InputDecoration(
                                    labelText: 'สำนักพิมพ์',
                                  ),
                                ),
                              ),
                              // Edition
                              Container(
                                child: TextFormField(
                                  controller: _textEdition,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? "กรุณากรอกครั้งที่พิมพ์"
                                        : int.parse(value) > 0
                                            ? null
                                            : "ครั้งที่พิมพ์ต้องมากกว่า 0";
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'ครั้งที่พิมพ์',
                                  ),
                                ),
                              ),
                              // price
                              Container(
                                child: TextFormField(
                                  controller: _textPrice,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? "กรุณากรอกราคา"
                                        : int.parse(value) > 0
                                            ? null
                                            : "ราคาต้องมากกว่า 0";
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'ราคาตามปก',
                                  ),
                                ),
                              ),
                              // type
                              SizedBox(height: 10,),
                              Container(
                                // width: double.infinity,
                                width: MediaQuery.of(context).size.width,
                                  child: AutocompleteLabel<String>(
                                fieldViewBuilder: (context,
                                    textEditingController,
                                    focusNode,
                                    onFieldSubmitted) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: 68),
                                    child: DryIntrinsicWidth(
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: TextFormField(
                                          strutStyle: StrutStyle(height: 1.0),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            border: InputBorder.none,
                                            // hintText: "เพิ่ม",
                                            labelText: "ประเภท",
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
                              )),
                              // เรื่องย่อ
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
                              // ปุ่มบันทึก
                              Container(
                                  margin:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (_bookInfoFormKey.currentState!
                                            .validate()) {
                                          try {
                                            if (widget.bookInfo == null) {
                                              await BookController()
                                                .addNewBook(
                                                    widget.accType,
                                                    _textISBN.text,
                                                    _textTitle.text,
                                                    _textAuthor.text,
                                                    _textPublisher.text,
                                                    int.parse(_textEdition.text),
                                                    int.parse(_textPrice.text),
                                                    typeOption!.values,
                                                    _textSynopsys.text,
                                                    _image)
                                                .then((value) => showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                          title: Text(
                                                              widget.accType == "ADMIN" ? "เสร็จสิ้น" : "รอการยืนยันจากผู้ดูแล"),
                                                          content: Text(
                                                              widget.accType == "ADMIN" ? "เพิ่มข้อมูลหนังสือใหม่เสร็จสิ้น" : 'ส่งข้อมูลเสร็จสิ้น รอการยืนยันจากผู้ดูแล'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              BottomBar(
                                                                                accType: widget.accType,
                                                                                tab: "PROFILE",
                                                                              )),
                                                                );
                                                              },
                                                              child: const Text(
                                                                  'ตกลง'),
                                                            ),
                                                          ],
                                                        )));
                                            } else {
                                              await BookController().updateBookInfo('${widget.bookInfo!['isbn']}_${widget.bookInfo!['edition']}', _textTitle.text, _textAuthor.text, _textPublisher.text, int.parse(_textPrice.text), widget.bookInfo!['types'], typeOption!.values, _textSynopsys.text, widget.bookInfo!['coverImage'], _image)
                                                .then((value) => showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                          title: Text("เสร็จสิ้น"),
                                                          content: Text("อัพเดทข้อมูลหนังสือเสร็จสิ้น"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              BottomBar(
                                                                                accType: widget.accType,
                                                                                tab: "PROFILE",
                                                                              )),
                                                                );
                                                              },
                                                              child: const Text(
                                                                  'ตกลง'),
                                                            ),
                                                          ],
                                                        )));
                                            }
                                          } on FirebaseException catch (e) {
                                            print(e.code);
                                            showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                        title: Text(e.message
                                                            .toString()),
                                                        content: Text(
                                                            "เกิดข้อผิดพลาดในการทำงาน กรุณาลองใหม่"),
                                                        actions: <Widget>[
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
                                      child: Text(widget.bookInfo == null ? "บันทึก" : widget.bookInfo!['approveStatus'] ? "บันทึก" : "อนุมัติ",
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

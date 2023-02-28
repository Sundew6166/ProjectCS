import 'package:flutter/material.dart';

class AddSale extends StatefulWidget {
  const AddSale({super.key});

  @override
  State<AddSale> createState() => _AddSaleState();
}

class _AddSaleState extends State<AddSale> {
  static var _addressValidationForm = GlobalKey<FormState>();

  TextEditingController _textISBN = TextEditingController();
  TextEditingController _textTitle = TextEditingController();
  TextEditingController _textAuthor = TextEditingController();
  TextEditingController _textPublisher = TextEditingController();
  TextEditingController _textPrice = TextEditingController();
  TextEditingController _textEdition = TextEditingController();

  TextEditingController _textDetail = TextEditingController();
  TextEditingController _textSellingPrice = TextEditingController();
  TextEditingController _textDeliveryFee = TextEditingController();
  TextEditingController _textNameBankAccount = TextEditingController();
  TextEditingController _textAccountNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ขาย'),
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
                                  enabled: false,
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
                                  enabled: false,
                                  controller: _textTitle,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'ชื่อหนังสือ',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  enabled: false,
                                  controller: _textPrice,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'ราคาตามปก',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  enabled: false,
                                  controller: _textEdition,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'ครั้งที่พิมพ์',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textDetail,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
                                  decoration: InputDecoration(
                                    labelText: 'รายละเอียดสินค้า',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textSellingPrice,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
                                  decoration: InputDecoration(
                                    labelText: 'ราคาขาย',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textDeliveryFee,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
                                  decoration: InputDecoration(
                                    labelText: 'ค่าส่ง',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textNameBankAccount,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
                                  decoration: InputDecoration(
                                    labelText: 'ธนาคาร',
                                  ),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _textAccountNumber,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  // validator: (value) {
                                  //   return (value!.isNotEmpty &&
                                  //           value.length != 10)
                                  //       ? 'กรอกเบอร์โทรศัพท์ไม่ถูกต้อง'
                                  //       : null;
                                  // },
                                  decoration: InputDecoration(
                                    labelText: 'เลขบัญชี',
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
                                                        "ยืนยันเพื่อเพิ่มไปยังการขาย"),
                                                    content: Text(
                                                        'ยืนยันเพื่อเพิ่มไปยังการขาย'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'ยกเลิก'),
                                                        child: const Text(
                                                            'ยกเลิก'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'ตกลง'),
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

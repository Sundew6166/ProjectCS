import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Service/SaleController.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({super.key, required this.saleInfo});

  Map<String, dynamic> saleInfo;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  File? _image;

  final _picker = ImagePicker();

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('แจ้งชำระเงิน'),
        ),
        body: Container(
            color: const Color(0xfff5f3e8),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    color: Colors.white,
                    child: Column(children: [
                      BookName(
                          title: widget.saleInfo['title'],
                          price: widget.saleInfo['sellingPrice']),
                      DeliveryFee(deliveryFee: widget.saleInfo['deliveryFee']),
                      Address(deliveryInfo: widget.saleInfo['deliveryInfo']),
                      Total(
                          total: widget.saleInfo['sellingPrice'] +
                              widget.saleInfo['deliveryFee']),
                      Bank(name: widget.saleInfo['bank'],number: widget.saleInfo['bankAccountNumber'])
                    ])),
                PaymentSlip(),
                const SizedBox(height: 20),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
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
                    child: const Text('เลือกรูป'),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                    onPressed: (() async {
                      if (_image != null) {
                        try {
                          await SaleController()
                              .informPayment(
                                  widget.saleInfo['idSales'], _image!)
                              .then((value) => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: const Text("เสร็จสิ้น"),
                                        content: const Text(
                                            "แจ้งชำระเงินเสร็จสิ้น อย่าลืมเพิ่มหนังสือเข้าคลังหลังจากได้รับหนังสือแล้ว"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BottomBar(
                                                            accType: 'USER',
                                                            tab: "PROFILE"))),
                                            child: const Text('ตกลง'),
                                          ),
                                        ],
                                      )));
                        } on FirebaseException catch (e) {
                          print(e.code);
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                      title: Text(e.message.toString()),
                                      content: const Text(
                                          "เกิดข้อผิดพลาดในการทำงาน กรุณาลองใหม่"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('ตกลง'),
                                        )
                                      ]));
                        }
                      }
                    }),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                      10,
                    ))),
                    child:
                        const Text("บันทึก", style: TextStyle(fontSize: 20))),
              ],
            ))));
  }
}

class BookName extends StatelessWidget {
  BookName({super.key, required this.title, required this.price});
  String title;
  int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(title, style: const TextStyle(fontSize: 20)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('${price} บ.',
                  style: const TextStyle(fontSize: 20, color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryFee extends StatelessWidget {
  DeliveryFee({super.key, required this.deliveryFee});
  int deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('ค่าจัดส่ง', style: TextStyle(fontSize: 20)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('${deliveryFee} บ.',
                  style: const TextStyle(fontSize: 20, color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}

class Address extends StatelessWidget {
  Address({super.key, required this.deliveryInfo});
  String deliveryInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('ข้อมูลการจัดส่ง', style: TextStyle(fontSize: 20)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(deliveryInfo,
                style: const TextStyle(fontSize: 20, color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}

class Total extends StatelessWidget {
  Total({super.key, required this.total});
  int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('ยอดรวม', style: TextStyle(fontSize: 20)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('${total} บ.',
                  style: const TextStyle(fontSize: 20, color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}

class Bank extends StatelessWidget {
  Bank({super.key, required this.name, required this.number});
  String name;
  String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('ชื่อธนาคาร', style: TextStyle(fontSize: 20)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(name,
                style: const TextStyle(fontSize: 20, color: Colors.black54)),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('เลขบัญชีธนาคาร', style: TextStyle(fontSize: 20)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(number,
                style: const TextStyle(fontSize: 20, color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}

class PaymentSlip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: const <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('หลักฐานการชำระเงิน', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}

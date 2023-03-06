import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:my_book/Screen/BottomBar.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

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
            color: Color(0xfff5f3e8),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    color: Colors.white,
                    child: Column(children: [
                      BookName(),
                      DeliveryFee(),
                      Address(),
                      Total(),
                    ])),
                PaymentSlip(),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: Container(
                      child: _image != null
                          ? Image.file(_image!, fit: BoxFit.cover)
                          : const Text('กรุณาเลือกรูป'),
                    )),
                // เลือกรูป
                Center(
                  child: ElevatedButton(
                    onPressed: _openImagePicker,
                    child: const Text('เลือกรูป'),
                  ),
                ),

                SizedBox(height: 40),
                Container(
                    child: ElevatedButton(
                        onPressed: (() => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomBar(
                                        accType: 'USER',
                                      )),
                            )),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                          10,
                        ))),
                        child: Text("บันทึก", style: TextStyle(fontSize: 20)))),
              ],
            )));
  }
}

class BookName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text('ชื่อหนังสือ', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('500 บ.',
                    style: TextStyle(fontSize: 20, color: Colors.red)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryFee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text('ค่าจัดส่ง', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('20 บ.',
                    style: TextStyle(fontSize: 20, color: Colors.red)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Address extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text('ที่อยู่', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text(
                    '\tหมู่ที่ 7 4 ถ. ลาดปลาเค้า แขวงจรเข้บัว เขตลาดพร้าว กรุงเทพมหานคร 10230',
                    style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Total extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text('ยอดรวม', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('520 บ.',
                    style: TextStyle(fontSize: 20, color: Colors.red)),
              ),
            ),
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
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child:
                    Text('หลักฐานการชำระเงิน', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

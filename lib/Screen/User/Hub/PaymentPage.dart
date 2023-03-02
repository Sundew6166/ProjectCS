import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

import 'package:my_book/Screen/BottomBar.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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
                BookName(),
                DeliveryFee(),
                Address(),
                Total(),
                PaymentSlip(),
                SizedBox(height: 20),
                UploadSlip(),
                SizedBox(height: 40),
                Container(
                    // margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: ElevatedButton(
                        onPressed: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomBar()),
                          )),
                        style: ElevatedButton.styleFrom(
                            // fixedSize: Size(400, 40), // specify width, height
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

class UploadSlip extends StatefulWidget {
  const UploadSlip({super.key});

  @override
  State<UploadSlip> createState() => _UploadSlipState();
}

class _UploadSlipState extends State<UploadSlip> {
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
    } else {
      // print("No image selected");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('คุณยังไม่ได้เลือกรูป')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5), // Image border
        child: Image.asset('images/uploadImage.png'),
      ),
    );
  }
}

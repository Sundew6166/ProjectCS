import 'package:flutter/material.dart';
import 'package:my_book/User/Profile/ProfilePage.dart';


class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  bool buttonenabled = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // title: const Text('ชื่อหนังสือ'),
            ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
                color: Color(0xfff5f3e8),
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    ImageProduct(),
                    BookName(),
                    Author(),
                    Publisher(),
                    Type(),
                    Price(),
                    Selling_Price(),
                    DeliveryFee(),
                    Synopsys(),
                    Detail(),
                    Container(
                        margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: ElevatedButton(
                            onPressed: (() => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: const Text("ยืนยันการซื้อหนังสือ"),
                                      content: Text(
                                          'ชื่อหนังสือ\nราคารวม XXXX บาท'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'ยกเลิก'),
                                          child: const Text('ยกเลิก'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Profile())),
                                          child: const Text('ตกลง'),
                                        ),
                                        
                                      ],
                                    ))),
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(100, 40), // specify width, height
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                  10,
                                ))),
                            child:
                                Text("ซื้อ", style: TextStyle(fontSize: 20)))),
                  ],
                ))));
  }
}

class ImageProduct extends StatelessWidget {
  const ImageProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5), // Image border
        child: Image.asset('images/Conan.jpg'),
      ),
    );
  }
}

class BookName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text('ชื่อหนังสือ', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class Selling_Price extends StatelessWidget {
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
                child: Text('ราคาขาย : ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('XXXX บาท',
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Author extends StatelessWidget {
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
                child: Text('ชื่อผู้แต่ง : ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('XXXXX XXXXX',
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Publisher extends StatelessWidget {
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
                child: Text('สำนักพิมพ์ : ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('XXXXXXX',
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Price extends StatelessWidget {
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
                child: Text('ราคาปก : ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('XXXX บาท',
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryFee  extends StatelessWidget {
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
                child: Text('ค่าจัดส่ง : ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('XXXX บาท',
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Type extends StatelessWidget {
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
                child: Text('ประเภทหนังสือ : ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('XXX',
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Synopsys extends StatelessWidget {
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
                child: Text('เรื่องย่อ : ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text('\t\t\t\tXXXXXXXXXXXXXX',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Detail extends StatelessWidget {
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
                child:
                    Text('รายละเอียดอื่น ๆ : ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text('\t\t\t\tXXXXXXXXXXXXXX',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

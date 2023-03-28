import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Service/AccountController.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/SaleController.dart';

class BuyPage extends StatefulWidget {
  BuyPage({super.key, required this.saleInfo});

  Map<String, dynamic> saleInfo;

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  bool canBuy = false;
  bool statusBuy = false;
  late String address;

  @override
  void initState() {
    setCanBuy();
    super.initState();
  }

  setCanBuy() async {
    if (widget.saleInfo['seller'] != FirebaseAuth.instance.currentUser!.uid) {
      await AccountController().getDeliveryInformation().then((value) {
        setState(() {
          address = value['address'];
        });
      });
      await BookController()
          .checkHasBook(widget.saleInfo['book']['isbn'],
              widget.saleInfo['book']['edition'].toString())
          .then((value) {
        setState(() {
          canBuy = !value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ซื้อ'),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
            color: const Color(0xfff5f3e8),
            // alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                ImageProduct(urlImage: widget.saleInfo['image']),
                const SizedBox(height: 20),
                Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    color: Colors.white,
                    child: Column(children: [
                      BookName(title: widget.saleInfo['book']['title']),
                      Author(author: widget.saleInfo['book']['author']),
                      Publisher(
                          publisher: widget.saleInfo['book']['publisher']),
                      Type(types: widget.saleInfo['book']['types']),
                      Selling_Price(
                          sellingPrice:
                              widget.saleInfo['sellingPrice'].toString()),
                      DeliveryFee(
                          deliveryFee:
                              widget.saleInfo['deliveryFee'].toString()),
                      Synopsys(synopsys: widget.saleInfo['book']['synopsys']),
                      Detail(detail: widget.saleInfo['detail']),
                    ])),
                Container(
                    margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: ElevatedButton(
                        onPressed: (canBuy)
                            ? () {
                                address.isEmpty
                                    ? showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text(
                                                  "ไม่สามารถสั่งซื้อได้"),
                                              content: const Text(
                                                  "กรุณากรอกที่อยู่เพื่อจัดส่งก่อนทำรายการใหม่อีกครั้ง"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('ตกลง')),
                                              ],
                                            ))
                                    : showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text(
                                                  "ยืนยันการซื้อหนังสือ"),
                                              content: Text(
                                                  '${widget.saleInfo['book']['title']}\nราคารวม ${widget.saleInfo['sellingPrice'] + widget.saleInfo['deliveryFee']} บาท'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'ยกเลิก'),
                                                  child: const Text('ยกเลิก'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      await SaleController()
                                                          .buyBook(widget
                                                              .saleInfo['id'])
                                                          .then((value) {
                                                        setState(() {
                                                          statusBuy = value;
                                                        });
                                                        if (statusBuy) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      BottomBar(
                                                                          accType:
                                                                              'USER',
                                                                          tab:
                                                                              "HOME")));
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder: (_) =>
                                                                  AlertDialog(
                                                                      title: const Text(
                                                                          "ไม่สามารถซื้อได้ในขณะนี้"),
                                                                      content:
                                                                          const Text(
                                                                              "มีคนอื่นกำลังซื้ออยู่"),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed: () => Navigator.of(
                                                                              context)
                                                                            ..pop()
                                                                            ..pop()
                                                                            ..pop(),
                                                                          child:
                                                                              const Text('ตกลง'),
                                                                        )
                                                                      ]));
                                                        }
                                                      });
                                                    } on FirebaseException catch (e) {
                                                      print(e.code);
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              AlertDialog(
                                                                  title: Text(e
                                                                      .message
                                                                      .toString()),
                                                                  content:
                                                                      const Text(
                                                                          "เกิดข้อผิดพลาดในการซื้อหนังสือ กรุณาลองใหม่"),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child: const Text(
                                                                          'ตกลง'),
                                                                    )
                                                                  ]));
                                                    }
                                                  },
                                                  child: const Text('ตกลง'),
                                                ),
                                              ],
                                            ));
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                              10,
                            ))),
                        child: const Text("ซื้อ",
                            style: TextStyle(fontSize: 20)))),
              ],
            ))));
  }
}

class ImageProduct extends StatelessWidget {
  ImageProduct({super.key, required this.urlImage});
  String urlImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(urlImage),
      ),
    );
  }
}

class BookName extends StatelessWidget {
  BookName({super.key, required this.title});
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(title, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}

class Selling_Price extends StatelessWidget {
  Selling_Price({super.key, required this.sellingPrice});
  String sellingPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('ราคาขาย : ', style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('$sellingPrice บาท',
                  style: const TextStyle(fontSize: 16, color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}

class Author extends StatelessWidget {
  Author({super.key, required this.author});
  String author;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('ชื่อผู้แต่ง : ', style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(author,
                  style: const TextStyle(
                    fontSize: 16,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class Publisher extends StatelessWidget {
  Publisher({super.key, required this.publisher});
  String publisher;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('สำนักพิมพ์ : ', style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(publisher,
                  style: const TextStyle(
                    fontSize: 16,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryFee extends StatelessWidget {
  DeliveryFee({super.key, required this.deliveryFee});
  String deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('ค่าจัดส่ง : ', style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('$deliveryFee บาท',
                  style: const TextStyle(
                    fontSize: 16,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class Type extends StatelessWidget {
  Type({super.key, required this.types});
  List<String> types;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('ประเภทหนังสือ : ', style: TextStyle(fontSize: 16)),
            ),
          ),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: [for (var type in types) _buildChip(type)],
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      labelPadding: const EdgeInsets.all(2.0),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: const Color(0xffadd1dc),
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(8.0),
    );
  }
}

class Synopsys extends StatelessWidget {
  Synopsys({super.key, required this.synopsys});
  String synopsys;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('เรื่องย่อ : ', style: TextStyle(fontSize: 16)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(synopsys, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class Detail extends StatelessWidget {
  Detail({super.key, required this.detail});
  String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('รายละเอียดอื่น ๆ : ', style: TextStyle(fontSize: 16)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(detail, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

// มาจาก หนังสือแนะนำ หนังสือในคลัง ค้นหาหนังสือ
class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Color _iconColor = Colors.black;

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
                    Row(
                      // mainAxisSize: MainAxisSize.min,

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 50,
                          // height: 300,
                          color: Colors.black,
                        ),
                        ImageProduct(),
                        Column(
                          children: [
                            // TODO: change color button
                            IconButton(
                              icon: const Icon(
                                Icons.book, size: 45,
                              ),

                              color: _iconColor,
                              onPressed: (() {
                                setState(() {
                                  _iconColor = Colors.green;
                                });
                              }),
                              // size: 45,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              Icons.shopping_cart,
                              size: 45,
                            ),
                          ],
                        )
                      ],
                    ),
                    // ImageProduct(),
                    BookName(),
                    Author(),
                    Publisher(),
                    Type(),
                    Price(),
                    Synopsys(),
                    Container(
                        margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: ElevatedButton(
                            onPressed: () {},
                            // onPressed: (() => showDialog(
                            //     context: context,
                            //     builder: (_) => AlertDialog(
                            //           title: const Text("ยืนยันการซื้อหนังสือ"),
                            //           content: Text(
                            //               'ชื่อหนังสือ\nราคารวม XXXX บาท'),
                            //           actions: <Widget>[
                            //             TextButton(
                            //               onPressed: () =>
                            //                   Navigator.pop(context, 'ยกเลิก'),
                            //               child: const Text('ยกเลิก'),
                            //             ),
                            //             TextButton(
                            //               onPressed: () =>
                            //                   Navigator.push(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                     builder: (context) =>
                            //                         BottomBar())),
                            //               child: const Text('ตกลง'),
                            //             ),

                            //           ],
                            //         ))),
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

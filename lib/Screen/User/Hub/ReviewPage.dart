import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Screen/User/Scan/AddSale.dart';

// มาจาก หนังสือแนะนำ หนังสือในคลัง ค้นหาหนังสือ
class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // TODO: ดึงหนังสือในคลังมาเช็ค
  bool _isBookOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('รีวิวหนังสือ'),
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
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 50,
                          // height: 300,
                          // color: Colors.black,
                        ),
                        ImageProduct(),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.book,
                                size: 45,
                                color: _isBookOn ? Colors.green : Colors.black,
                              ),
                              onPressed: (() {
                                setState(() {
                                  // TODO: Alert before delete book from stock
                                  _isBookOn = !_isBookOn;
                                  print(_isBookOn);
                                });
                              }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (_isBookOn)
                              IconButton(
                                  icon: const Icon(
                                    Icons.shopping_cart,
                                    size: 45,
                                    color: Colors.red,
                                  ),
                                  onPressed: (() => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddSale()),
                                      ))),
                          ],
                        )
                      ],
                    ),
                    // ImageProduct(),
                    BookName(),
                    Author(),
                    Publisher(),
                    Edition(),
                    Type(),
                    Price(),
                    Synopsys(),
                    WriteReview(),
                    RateReview(),
                    // Container(
                    //     margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    //     child: ElevatedButton(
                    //         onPressed: () {},
                    //         // onPressed: (() => showDialog(
                    //         //     context: context,
                    //         //     builder: (_) => AlertDialog(
                    //         //           title: const Text("ยืนยันการซื้อหนังสือ"),
                    //         //           content: Text(
                    //         //               'ชื่อหนังสือ\nราคารวม XXXX บาท'),
                    //         //           actions: <Widget>[
                    //         //             TextButton(
                    //         //               onPressed: () =>
                    //         //                   Navigator.pop(context, 'ยกเลิก'),
                    //         //               child: const Text('ยกเลิก'),
                    //         //             ),
                    //         //             TextButton(
                    //         //               onPressed: () =>
                    //         //                   Navigator.push(
                    //         //                 context,
                    //         //                 MaterialPageRoute(
                    //         //                     builder: (context) =>
                    //         //                         BottomBar())),
                    //         //               child: const Text('ตกลง'),
                    //         //             ),

                    //         //           ],
                    //         //         ))),
                    //         style: ElevatedButton.styleFrom(
                    //             fixedSize:
                    //                 Size(100, 40), // specify width, height
                    //             shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(
                    //               10,
                    //             ))),
                    //         child:
                    //             Text("ซื้อ", style: TextStyle(fontSize: 20)))),
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

class Edition extends StatelessWidget {
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
                child: Text('ครั้งที่พิมพ์ : ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text('X',
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

class RateReview extends StatefulWidget {
  const RateReview({super.key});

  @override
  State<RateReview> createState() => _RateReviewState();
}

class _RateReviewState extends State<RateReview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      // width: 280,
      child: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(15), // Image border
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                margin: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Color(0xffadd1dc),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: const AssetImage("images/rambo.jpg"),
                          backgroundColor: Color(0xffadd1dc),
                          radius: 12,
                        ),
                        Text('\tUsername', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    // Text('Frame', style: TextStyle(color: Colors.grey[500])),
                    Text('\tรายละเอียดความเห็น',
                        style: TextStyle(fontSize: 12)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          RatingBarIndicator(
                            itemSize: 20,
                            // TODO: ดึงค่า rating มาแสดง
                            rating: 2.5,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Color(0xff795e35),
                            ),
                          ),
                          SizedBox(width: 30),
                          Row(
                            children: [
                              Text(
                                // TODO: ดึงค่า rating มาแสดง
                                '4.0',
                                style: TextStyle(
                                    color: Color(0xff795e35),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '/ 5.0',
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class WriteReview extends StatefulWidget {
  const WriteReview({super.key});

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  static var _keyValidationForm = GlobalKey<FormState>();
  TextEditingController textarea = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _keyValidationForm,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: const AssetImage("images/rambo.jpg"),
                    backgroundColor: Color(0xffadd1dc),
                    radius: 20,
                  ),
                  Text('\tUsername', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 20),
                  RatingBar.builder(
                    itemSize: 30,
                    initialRating: 3,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Color(0xff795e35),
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textarea,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                decoration: InputDecoration(
                    filled: true, //<-- SEE HERE
                    fillColor: Colors.white,
                    hintText: "พิมพ์ข้อความลงในนี้...",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: const Color(0xff795e35)))),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_keyValidationForm.currentState!.validate()) {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => BottomBar()),
                      // );
                      // print(textarea.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(400, 40), // specify width, height
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                        10,
                      ))),
                  child: Text("รีวิว", style: TextStyle(fontSize: 20)))
            ],
          ),
        ));
  }
}

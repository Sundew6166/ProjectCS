import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:my_book/Screen/User/Scan/AddSale.dart';
import 'package:my_book/Service/BookController.dart';

// มาจาก หนังสือแนะนำ หนังสือในคลัง ค้นหาหนังสือ
class ReviewPage extends StatefulWidget {
  ReviewPage({super.key, required this.isbn, required this.edition});

  String isbn;
  String edition;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // TODO: ดึงหนังสือในคลังมาเช็ค
  bool _isBookOn = false;
  Map<String, dynamic>? bookInfo;

  @override
  void initState() {
    setBookInfo();
    super.initState();
  }

  setBookInfo() async {
    await BookController()
        .getBookInfo(widget.isbn, widget.edition)
        .then((value) {
      setState(() {
        bookInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('รีวิวหนังสือ'),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: bookInfo != null
                ? Container(
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
                            ),
                            ImageProduct(
                                coverImageURL: bookInfo!['coverImage']),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.book,
                                    size: 45,
                                    color:
                                        _isBookOn ? Colors.green : Colors.black,
                                  ),
                                  onPressed: (() {
                                    setState(() {
                                      if (_isBookOn) {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: const Text(
                                                      "ลบออกจากคลังหนังสือ"),
                                                  content: Text(
                                                      'ยืนยันเพื่อลบออกจากคลังหนังสือ'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'ยกเลิก'),
                                                      child:
                                                          const Text('ยกเลิก'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          _isBookOn =
                                                              !_isBookOn;
                                                        });
                                                      },
                                                      child: const Text('ตกลง'),
                                                    ),
                                                  ],
                                                ));
                                      } else
                                        _isBookOn = !_isBookOn;
                                      // print(_isBookOn);
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
                                                builder: (context) =>
                                                    AddSale()),
                                          ))),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          color: Colors.white,
                          child: Column(
                            children: [
                              BookName(title: bookInfo!['title']),
                              Author(author: bookInfo!['author']),
                              Publisher(publisher: bookInfo!['publisher']),
                              Edition(edition: bookInfo!['edition'].toString()),
                              Price(price: bookInfo!['price'].toString()),
                              Type(types: bookInfo!['types']),
                              Synopsys(synopsys: bookInfo!['synopsys']),
                            ],
                          ),
                        ),
                        WriteReview(),
                        RateReview(),
                      ],
                    ))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black,
                    child: Center(
                      child: LoadingAnimationWidget.twistingDots(
                        leftDotColor: const Color(0xFF1A1A3F),
                        rightDotColor: const Color(0xFFEA3799),
                        size: 50,
                      ),
                    ),
                  )));
  }
}

class ImageProduct extends StatelessWidget {
  ImageProduct({super.key, required this.coverImageURL});
  String coverImageURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5), // Image border
        child: Image.network(coverImageURL),
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
      // margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(title, style: TextStyle(fontSize: 20)),
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
                child: Text(author,
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
  Edition({super.key, required this.edition});
  String edition;

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
                child: Text(edition,
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
  Publisher({super.key, required this.publisher});
  String publisher;

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
                child: Text(publisher,
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
  Price({super.key, required this.price});
  String price;

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
                child: Text('${price} บาท',
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
  Type({super.key, required this.types});
  List<String> types;

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
      labelPadding: EdgeInsets.all(2.0),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Color(0xffadd1dc),
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
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
                child: Text(synopsys, style: TextStyle(fontSize: 16)),
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
                            rating: 3,
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
                    minRating: 1,
                    direction: Axis.horizontal,
                    // allowHalfRating: true,
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
                      // TODO: reload this page
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

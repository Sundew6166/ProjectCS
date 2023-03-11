import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:my_book/Screen/User/Scan/AddSale.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/ReviewController.dart';

// มาจาก หนังสือแนะนำ หนังสือในคลัง ค้นหาหนังสือ
class ReviewPage extends StatefulWidget {
  ReviewPage({super.key, required this.bookInfo, required this.hasBook, required this.hasSale});

  Map<String, dynamic> bookInfo;
  bool hasBook;
  bool hasSale;
  String? idbook;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<dynamic>? reviews;
  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
    await ReviewController()
        .getReview(
            widget.bookInfo!['edition'].toString(), widget.bookInfo!['isbn'])
        .then((value) {
      setState(() {
        reviews = value;
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
            child: widget.bookInfo != null
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
                                coverImageURL: widget.bookInfo['coverImage']),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.book,
                                    size: 45,
                                    color: widget.hasBook
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                  onPressed: (() async {
                                    if (widget.hasBook) {
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
                                                        Navigator.pop(
                                                            context, 'ยกเลิก'),
                                                    child: const Text('ยกเลิก'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        await BookController().deleteBookFromLibrary(widget.bookInfo['isbn'], widget.bookInfo['edition'].toString())
                                                          .then((value) {setState(() {
                                                            widget.hasBook = false;
                                                            Navigator.pop(context);
                                                          });});
                                                      } on FirebaseException catch (e) {
                                                        print(e.code);
                                                        showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                AlertDialog(
                                                                    title: Text(e
                                                                        .message
                                                                        .toString()),
                                                                    content: Text(
                                                                        "เกิดข้อผิดพลาดในการเอาหนังสือออกจากคลัง กรุณาลองใหม่"),
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
                                    } else {
                                      try {
                                        await BookController().addBookToLibrary(widget.bookInfo['isbn'], widget.bookInfo['edition'].toString())
                                          .then((value) {setState(() {
                                            widget.hasBook = true;
                                          });
                                        });
                                      } on FirebaseException catch (e) {
                                        print(e.code);
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                    title: Text(
                                                        e.message.toString()),
                                                    content: Text(
                                                        "เกิดข้อผิดพลาดในการเพิ่มหนังสือเข้าคลัง กรุณาลองใหม่"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child:
                                                            const Text('ตกลง'),
                                                      )
                                                    ]));
                                      }
                                    }
                                    // print(_isBookOn);
                                  }),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                if (widget.hasBook)
                                  IconButton(
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        size: 45,
                                        color: widget.hasSale ? Colors.black : Colors.red,
                                      ),
                                      onPressed: (() {
                                        if (!widget.hasSale)
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddSale(bookInfo: widget.bookInfo)),
                                          );
                                      })),
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
                              BookName(title: widget.bookInfo['title']),
                              Author(author: widget.bookInfo['author']),
                              Publisher(publisher: widget.bookInfo['publisher']),
                              Edition(edition: widget.bookInfo['edition'].toString()),
                              Price(price: widget.bookInfo['price'].toString()),
                              Type(types: widget.bookInfo['types']),
                              Synopsys(synopsys: widget.bookInfo['synopsys']),
                            ],
                          ),
                        ),
                        WriteReview(
                          edition: widget.bookInfo!['edition'].toString(),
                          isbn: widget.bookInfo!['isbn'],
                        ),
                        RateReview(reviews: reviews),
                      ],
                    ))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Color(0xfff5f3e8),
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
  RateReview({super.key, required this.reviews});
  List<dynamic>? reviews;

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
        itemCount: widget.reviews!.length,
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
                          backgroundImage: NetworkImage(
                              '${widget.reviews![index]['Image']}'),
                          backgroundColor: Color(0xffadd1dc),
                          radius: 12,
                        ),
                        Text('\t${widget.reviews![index]['CreateBy']}',
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Text('\t${widget.reviews![index]['Detail_Review']}',
                        style: TextStyle(fontSize: 14)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          RatingBarIndicator(
                            itemSize: 20,
                            rating: widget.reviews![index]['Rating'].toDouble(),
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Color(0xff795e35),
                            ),
                          ),
                          SizedBox(width: 20),
                          Row(
                            children: [
                              Text(
                                '${widget.reviews![index]['Rating']}',
                                style: TextStyle(
                                    color: Color(0xff795e35),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '/ 5',
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
  WriteReview({super.key, required this.edition, required this.isbn});
  String edition;
  String isbn;

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  TextEditingController textarea = TextEditingController();
  var rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
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
                initialRating: 0,
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
                  rate = rating;
                  // print(rating);
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            controller: textarea,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "พิมพ์ข้อความลงในนี้...",
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: const Color(0xff795e35)))),
          ),
          ElevatedButton(
              onPressed: () {
                rate != null
                    ? setState(() async {
                        try {
                          print(rate);
                          await ReviewController().addReview(
                              textarea.text, rate, widget.edition, widget.isbn);
                          // .then((value) => Navigator.pushReplacement(
                          //       context,
                          //       PageRouteBuilder(
                          //         pageBuilder: (BuildContext context,
                          //             Animation<double> animation1,
                          //             Animation<double> animation2) {
                          //           return super.widget;
                          //         },
                          //         transitionDuration: Duration.zero,
                          //         reverseTransitionDuration: Duration.zero,
                          //       ),
                          //     ));
                        } on FirebaseException catch (e) {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                      title: Text(e.message.toString()),
                                      content: Text(
                                          "เกิดข้อผิดพลาดในการส่งข้อมูล กรุณาลองใหม่"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('ตกลง'),
                                        )
                                      ]));
                        }
                      })
                    : ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กรุณาให้คะแนน')),
                      );
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(400, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                    10,
                  ))),
              child: Text("รีวิว", style: TextStyle(fontSize: 20)))
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:my_book/Screen/User/Scan/AddSale.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/ReviewController.dart';

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

  Future<void> setData() async {
    await ReviewController().getReview(widget.bookInfo["edition"].toString(), widget.bookInfo["isbn"])
      .then((value) => setState(() => reviews = value));
  }

  @override
  Widget build(BuildContext context) {
    return (reviews != null)
      ? Scaffold(
          appBar: AppBar(
            title: const Text("รีวิวหนังสือ"),
          ),
          resizeToAvoidBottomInset: true,
          body: RefreshIndicator(
            onRefresh: setData,
            child: Container(
              color: const Color(0xfff5f3e8),
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(alignment: Alignment.center, width: 50),
                        ImageProduct(coverImageURL: widget.bookInfo["coverImage"]),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.book, size: 45, color: widget.hasBook ? Colors.green : Colors.black),
                              onPressed: (() async {
                                if (widget.hasBook) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("ลบออกจากคลังหนังสือ"),
                                      content: const Text("ยืนยันเพื่อลบออกจากคลังหนังสือ"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, "ยกเลิก"),
                                          child: const Text("ยกเลิก"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await BookController().deleteBookFromLibrary(widget.bookInfo["isbn"], widget.bookInfo["edition"].toString())
                                                .then((value) {
                                                  setState(() {
                                                    widget.hasBook = false;
                                                    Navigator.pop(context);
                                                  });
                                                });
                                            } on FirebaseException catch (e) {
                                              print(e.code);
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: Text(e.message.toString()),
                                                  content: const Text("เกิดข้อผิดพลาดในการเอาหนังสือออกจากคลัง กรุณาลองใหม่"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text("ตกลง"),
                                                    )
                                                  ]
                                                )
                                              );
                                            }
                                          },
                                          child: const Text("ตกลง"),
                                        ),
                                      ],
                                    )
                                  );
                                } else {
                                  try {
                                    await BookController().addBookToLibrary(widget.bookInfo["isbn"], widget.bookInfo["edition"].toString())
                                      .then((value) => setState(() => widget.hasBook = true));
                                  } on FirebaseException catch (e) {
                                    print(e.code);
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(e.message.toString()),
                                        content: const Text("เกิดข้อผิดพลาดในการเพิ่มหนังสือเข้าคลัง กรุณาลองใหม่"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("ตกลง"),
                                          )
                                        ]
                                      )
                                    );
                                  }
                                }
                              }),
                            ),
                            const SizedBox(height: 20),
                            if (widget.hasBook)
                              IconButton(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  size: 45,
                                  color: widget.hasSale ? Colors.black : Colors.red,
                                ),
                                onPressed: (() {
                                  if (!widget.hasSale) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddSale(bookInfo: widget.bookInfo)));
                                  }
                                })
                              ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.white,
                      child: Column(
                        children: [
                          BookName(title: widget.bookInfo["title"]),
                          Author(author: widget.bookInfo["author"]),
                          Publisher(publisher: widget.bookInfo["publisher"]),
                          Edition(edition: widget.bookInfo["edition"].toString()),
                          Price(price: widget.bookInfo["price"].toString()),
                          Type(types: widget.bookInfo["types"]),
                          Synopsys(synopsys: widget.bookInfo["synopsys"]),
                        ],
                      ),
                    ),
                    WriteReview(
                      edition: widget.bookInfo["edition"].toString(),
                      isbn: widget.bookInfo["isbn"],
                      reviews: reviews!
                    ),
                  ],
                )
              )
            )
          )
        )
      : Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: Lottie.network("https://assets10.lottiefiles.com/packages/lf20_0M2ci9pi4Y.json"),
          ),
        );
  }
}

class ImageProduct extends StatelessWidget {
  ImageProduct({super.key, required this.coverImageURL});
  String coverImageURL;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 20)
        ),
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
              child: Text("ชื่อผู้แต่ง : \n", style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                author,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16)
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
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("ครั้งที่พิมพ์ : ", style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                edition,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16)
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
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("สำนักพิมพ์ : \n", style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                publisher,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16)
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
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("ราคาปก : ", style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "$price บาท",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16)
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
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("ประเภท : \n", style: TextStyle(fontSize: 16)),
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
      label: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black)),
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
            child: Text("เรื่องย่อ : ", style: TextStyle(fontSize: 16)),
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

class WriteReview extends StatefulWidget {
  WriteReview({super.key, required this.edition, required this.isbn, required this.reviews});

  String edition;
  String isbn;
  List<dynamic> reviews;

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController textarea = TextEditingController();
  double rate = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user!.photoURL.toString()),
            backgroundColor: const Color(0xffadd1dc),
            radius: 20,
          ),
          Text(
            "\t${user!.displayName.toString()}",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16)
          ),
          const SizedBox(width: 10),
          RatingBar.builder(
            itemSize: 40,
            minRating: 1,
            initialRating: rate,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);
                case 1:
                  return const Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent);
                case 2:
                  return const Icon(Icons.sentiment_neutral, color: Colors.amber);
                case 3:
                  return const Icon(Icons.sentiment_satisfied, color: Colors.lightGreen);
                default:
                  return const Icon(Icons.sentiment_very_satisfied, color: Colors.green);
              }
            },
            onRatingUpdate: (rating) {
              rate = rating;
            },
          ),
          const SizedBox(height: 10),
          TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: textarea,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            maxLines: 4,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "พิมพ์ข้อความลงในนี้...",
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Color(0xff795e35)))
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (rate != 0.0) {
                try {
                  await ReviewController().addReview(textarea.text, rate, widget.edition, widget.isbn)
                    .then((value) async {
                      await ReviewController().getReview(widget.edition, widget.isbn)
                        .then((value) => setState(() => widget.reviews = value));
                    });
                } on FirebaseException catch (e) {
                  print(e.code);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(e.message.toString()),
                      content: const Text("เกิดข้อผิดพลาดในการส่งข้อมูล กรุณาลองใหม่"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("ตกลง")
                        )
                      ]
                    )
                  );
                }
                textarea.clear();
                rate = 0.0;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("กรุณาให้คะแนนหนังสือ",
                          style: TextStyle(fontSize: 18)),
                      backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(400, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            child: const Text("รีวิว", style: TextStyle(fontSize: 20))
          ),
          rateReview(widget.reviews)
        ],
      ),
    );
  }

  Widget rateReview(reviews) {
    return ListView.builder(
      itemCount: widget.reviews.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: const BoxDecoration(color: Color(0xffadd1dc)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage("${widget.reviews[index]["Image"]}"),
                      backgroundColor: const Color(0xffadd1dc),
                      radius: 12,
                    ),
                    Text(
                      "\t${widget.reviews[index]["CreateBy"]}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14)
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "${widget.reviews[index]["Detail_Review"]}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14)
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      RatingBarIndicator(
                        itemSize: 20,
                        rating: widget.reviews[index]["Rating"].toDouble(),
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return const Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);
                            case 1:
                              return const Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent);
                            case 2:
                              return const Icon(Icons.sentiment_neutral, color: Colors.amber);
                            case 3:
                              return const Icon(Icons.sentiment_satisfied, color: Colors.lightGreen);
                            default:
                              return const Icon(Icons.sentiment_very_satisfied, color: Colors.green);
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Text("${widget.reviews[index]["Rating"]}", style: const TextStyle(color: Color(0xff795e35), fontWeight: FontWeight.bold)),
                          Text("/ 5.0", style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }
}

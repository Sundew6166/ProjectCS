import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/SaleController.dart';
import 'package:my_book/Service/SearchController.dart';

class BookSearch extends StatefulWidget {
  BookSearch({super.key, required this.text});
  String? text;

  @override
  State<BookSearch> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  List<dynamic>? bookList;

  @override
  void initState() {
    setData();
    super.initState();
  }

  Future<void> setData() async {
    await SearchController().getBooks(widget.text!)
      .then((value) => setState(() => bookList = value));
  }

  @override
  Widget build(BuildContext context) {
    return bookList != null
      ? Scaffold(
          body: (bookList!.isEmpty)
            ? Container(
                padding: const EdgeInsets.fromLTRB(150, 20, 0, 0),
                child: const Text("ไม่มีหนังสือ", style: TextStyle(fontSize: 18))
              )
            : Container(
                color: const Color(0xfff5f3e8),
                child: BookCard(books: bookList!),
              )
        )
      : Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: Lottie.network("https://assets1.lottiefiles.com/packages/lf20_yyytgjwe.json"),
          ),
        );
  }
}

class BookCard extends StatelessWidget {
  BookCard({super.key, required this.books});
  List<dynamic> books;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemCount: books.length,
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
            onTap: () async {
              var bookInfo = books[index];
              var hasBook = await BookController().checkHasBook(bookInfo!["isbn"], bookInfo["edition"].toString());
              var hasSale = hasBook ? await SaleController().checkHasSale(bookInfo!["isbn"], bookInfo["edition"].toString()) : false;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage(bookInfo: bookInfo, hasBook: hasBook, hasSale: hasSale)));
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(books[index]["coverImage"]),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            books[index]["title"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15)
                          ),
                          Text(
                            books[index]["author"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ]
                      )
                    )
                  ],
                ),
              ),
            )
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.0,
          mainAxisExtent: 290,
        ),
      ),
    );
  }
}

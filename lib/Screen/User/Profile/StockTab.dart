import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Screen/User/Hub/AddBook.dart';
import 'package:my_book/Service/BookController.dart';

class StockTab extends StatefulWidget {
  StockTab({super.key, required this.accType, required this.bookList});

  String accType;
  List<dynamic> bookList;

  @override
  State<StockTab> createState() => _StockTabState();
}

class _StockTabState extends State<StockTab> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
    if (widget.accType == 'ADMIN') {
      await BookController().getAllBookInLibrary(widget.accType).then((value) {
        setState(() {
          widget.bookList = value;
        });
      });
    } else {
      await BookController().getAllBookInLibrary(widget.accType).then((value) {
        setState(() {
          widget.bookList = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.bookList != null
        ? Container(
            child: widget.bookList.isEmpty
                ? Container(
                    padding: const EdgeInsets.fromLTRB(150, 20, 0, 0),
                    child: const Text("ไม่มีหนังสือ",
                        style: TextStyle(fontSize: 18)))
                : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: widget.bookList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {
                              var bookInfo = widget.bookList[index]!;
                              if (widget.accType == "ADMIN") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddBook(
                                            accType: widget.accType,
                                            bookInfo: bookInfo)));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReviewPage(
                                            bookInfo: bookInfo,
                                            hasBook: true,
                                            hasSale: false)));
                              }
                            },
                            child: SizedBox(
                                height: 100,
                                child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.network(
                                                    widget.bookList[index]![
                                                        'coverImage']),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              widget.bookList[
                                                                      index]![
                                                                  'title'],
                                                                  maxLines: 2,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                          Expanded(
                                                              child: Text(
                                                            widget.bookList[
                                                                index]!['isbn'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ))
                                                        ])),
                                              ),
                                            ])))));
                      },
                    ),
                  ))
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xfff5f3e8),
            child: Center(
              child: Lottie.network(
                  'https://assets1.lottiefiles.com/packages/lf20_yyytgjwe.json'),
            ),
          );
  }
}

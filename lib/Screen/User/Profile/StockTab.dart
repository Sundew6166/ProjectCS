import 'package:flutter/material.dart';

import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Screen/User/Hub/AddBook.dart';
import 'package:my_book/Service/BookController.dart';

class StockTab extends StatefulWidget {
  StockTab({super.key, required this.accType});

  String accType;

  @override
  State<StockTab> createState() => _StockTabState();
}

class _StockTabState extends State<StockTab> {
  List<Map<String,dynamic>?> bookList = [];

  @override
  void initState() {
    setBookList();
    super.initState();
  }

  setBookList() async {
    await BookController().getAllBookInLibrary(widget.accType).then((value) {
      setState(() {
        bookList.addAll(value);
      });
    });
  }

  // TODO: admin and user
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: Color(0xfff5f3e8),
      child: new ListView.builder(
        // padding: const EdgeInsets.all(5),
        itemCount: bookList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
              // TODO: if user => ReviewPage
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewPage(bookInfo: bookList[index], hasBook: true)),
                  ),

              // TODO: if admin => AddBook
              // onTap: () => Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => AddBook()),
              //     ),
              
              child: Container(
                  height: 100,
                  child: Card(
                      child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(5), // Image border
                                  child: Image.network(bookList[index]!['coverImage']),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(bookList[index]!['title'],
                                                style: TextStyle(fontSize: 18)),
                                            Expanded(
                                                child: Text(
                                              bookList[index]!['isbn'],
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                          ])),
                                ),
                                // Text("03.03.2020"),
                              ])))));
        },
      ),
    ));
  }
}

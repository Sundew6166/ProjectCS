import 'package:flutter/material.dart';

import 'package:my_book/Screen/User/Hub/AddBook.dart';

import 'package:my_book/Service/BookController.dart';

class ApproveTab extends StatefulWidget {
  const ApproveTab({super.key});

  @override
  State<ApproveTab> createState() => _ApproveTabState();
}

class _ApproveTabState extends State<ApproveTab> {
  List<Map<String, dynamic>?> bookList = [];

  @override
  void initState() {
    setBookList();
    super.initState();
  }

  setBookList() async {
    await BookController().getAllBookPendingApproval().then((value) {
      setState(() {
        bookList.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: const Color(0xfff5f3e8),
      child: ListView.builder(
        itemCount: bookList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                var bookInfo = bookList[index];
                await BookController()
                    .getTypesOfBook(
                        '${bookInfo!['isbn']}_${bookInfo['edition']}')
                    .then((value) => bookInfo.addAll({"types": value}));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddBook(accType: "ADMIN", bookInfo: bookInfo)),
                );
              },
              child: SizedBox(
                  height: 100,
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                      bookList[index]!['coverImage']),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(bookList[index]!['title'],
                                                style: const TextStyle(
                                                    fontSize: 18)),
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

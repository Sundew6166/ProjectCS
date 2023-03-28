import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Hub/AddBook.dart';

import 'package:my_book/Service/BookController.dart';

class ApproveTab extends StatefulWidget {
  const ApproveTab({super.key});

  @override
  State<ApproveTab> createState() => _ApproveTabState();
}

class _ApproveTabState extends State<ApproveTab> {
  List<dynamic>? approveList;
  @override
  void initState() {
    reFresh();
    super.initState();
  }

  Future<void> reFresh() async {
    await BookController().getAllBookPendingApproval().then((value) {
      setState(() {
        approveList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return approveList != null
        ? RefreshIndicator(
            onRefresh: reFresh,
            child: approveList!.isEmpty
                ? Container(
                    padding: const EdgeInsets.fromLTRB(130, 20, 0, 0),
                    child: const Text("ไม่มีการรออนุมัติ",
                        style: TextStyle(fontSize: 18)))
                : Container(
                    height: MediaQuery.of(context).size.height,
                    color: const Color(0xfff5f3e8),
                    child: ListView.builder(
                      itemCount: approveList!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {
                              var bookInfo = approveList![index];
                              await BookController()
                                  .getTypesOfBook(
                                      '${bookInfo!['isbn']}_${bookInfo['edition']}')
                                  .then((value) =>
                                      bookInfo.addAll({"types": value}));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddBook(
                                        accType: "ADMIN", bookInfo: bookInfo)),
                              );
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
                                                    approveList![index]
                                                        ['coverImage']),
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
                                                              approveList![
                                                                      index]
                                                                  ['title'],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                          Expanded(
                                                              child: Text(
                                                            approveList![index]
                                                                ['isbn'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ))
                                                        ])),
                                              ),
                                              // Text("03.03.2020"),
                                            ])))));
                      },
                    ),
                  ))
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: Lottie.network(
                  'https://assets1.lottiefiles.com/packages/lf20_yyytgjwe.json'),
            ),
          );
  }
}

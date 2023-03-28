import 'package:flutter/material.dart';

import 'package:my_book/Screen/User/Hub/AddBook.dart';

import 'package:my_book/Service/BookController.dart';

class ApproveTab extends StatefulWidget {
  ApproveTab({super.key, required this.approveList});
  List<dynamic> approveList;
  @override
  State<ApproveTab> createState() => _ApproveTabState();
}

class _ApproveTabState extends State<ApproveTab> {
  @override
  void initState() {
    reFresh();
    super.initState();
  }

  Future<void> reFresh() async {
    await BookController().getAllBookPendingApproval().then((value) {
      setState(() {
        widget.approveList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: reFresh,
        child: widget.approveList.isEmpty
            ? Container(
                padding: const EdgeInsets.fromLTRB(130, 20, 0, 0),
                child: const Text("ไม่มีการรออนุมัติ",
                    style: TextStyle(fontSize: 18)))
            : Container(
            height: MediaQuery.of(context).size.height,
            // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            color: const Color(0xfff5f3e8),
            child: ListView.builder(
                itemCount: widget.approveList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () async {
                        var bookInfo = widget.approveList[index];
                        await BookController()
                            .getTypesOfBook(
                                '${bookInfo!['isbn']}_${bookInfo['edition']}')
                            .then((value) => bookInfo.addAll({"types": value}));
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
                                              widget.approveList[index]
                                                  ['coverImage']),
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        widget.approveList[
                                                            index]['title'],
                                                        style: const TextStyle(
                                                            fontSize: 18)),
                                                    Expanded(
                                                        child: Text(
                                                      widget.approveList[index]
                                                          ['isbn'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
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

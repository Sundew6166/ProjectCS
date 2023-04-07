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
    setData();
    super.initState();
  }

  Future<void> setData() async {
    await BookController().getAllBookPendingApproval()
      .then((value) => setState(() => approveList = value));
  }

  @override
  Widget build(BuildContext context) {
    return (approveList != null)
      ? RefreshIndicator(
          onRefresh: setData,
          child: (approveList!.isEmpty)
            ? const CustomScrollView(
                slivers: <Widget>[
                  SliverFillRemaining(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(130, 20, 0, 0),
                      child: Text("ไม่มีหนังสือรอการอนุมัติ", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: approveList!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        var bookInfo = approveList![index];
                        await BookController().getTypesOfBook("${bookInfo!["isbn"]}_${bookInfo["edition"]}")
                          .then((value) => bookInfo.addAll({"types": value}));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddBook(accType: "ADMIN", bookInfo: bookInfo)));
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
                                  child: Image.network(approveList![index]["coverImage"]),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          approveList![index]["title"],
                                          maxLines: 2,
                                          overflow:TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 18)
                                        ),
                                        Expanded(
                                          child: Text(approveList![index]["isbn"], overflow: TextOverflow.ellipsis)
                                        )
                                      ]
                                    )
                                  ),
                                ),
                              ]
                            )
                          )
                        )
                      )
                    );
                  },
                ),
              )
        )
      : Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xfff5f3e8),
          child: Center(
            child: Lottie.network("https://assets1.lottiefiles.com/packages/lf20_yyytgjwe.json")
          ),
        );
  }
}

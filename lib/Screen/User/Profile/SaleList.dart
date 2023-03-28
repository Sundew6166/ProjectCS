import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_book/Screen/User/Hub/BuyPage.dart';
import 'package:my_book/Service/SaleController.dart';

class SaleList extends StatefulWidget {
  const SaleList({super.key});

  @override
  State<SaleList> createState() => _SaleListState();
}

class _SaleListState extends State<SaleList> {
  List<dynamic>? saleList;
  @override
  void initState() {
    reFresh();
    super.initState();
  }

  Future<void> reFresh() async {
    await SaleController().getMySale().then((value) {
      setState(() {
        saleList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return saleList != null
        ? RefreshIndicator(
            onRefresh: reFresh,
            child: saleList != null
                ? Container(
                    padding: const EdgeInsets.fromLTRB(130, 20, 0, 0),
                    child: const Text("ไม่มีการขาย",
                        style: TextStyle(fontSize: 18)))
                : Container(
                    height: MediaQuery.of(context).size.height,
                    // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    color: const Color(0xfff5f3e8),
                    child: ListView.builder(
                      itemCount: saleList!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BuyPage(saleInfo: saleList![index])),
                                ),
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
                                                    saleList![index]
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
                                                              saleList![index]
                                                                  ['title'],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                          Expanded(
                                                              child: Text(
                                                            saleList![index]
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
                  'https://assets10.lottiefiles.com/packages/lf20_0M2ci9pi4Y.json'),
            ),
          );
  }
}

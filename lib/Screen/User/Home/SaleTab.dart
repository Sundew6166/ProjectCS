import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Hub/BuyPage.dart';
import 'package:my_book/Service/SaleController.dart';
import 'package:my_book/Service/SearchController.dart';

class SaleTab extends StatefulWidget {
  SaleTab({super.key, required this.page, this.text});
  String? text;
  String? page;

  @override
  State<SaleTab> createState() => _SaleTabState();
}

class _SaleTabState extends State<SaleTab> {
  List<dynamic>? saleList;
  @override
  void initState() {
    setData();
    super.initState();
  }

  Future<void> setData() async {
    if (widget.page == 'home') {
      await SaleController().getAllSale().then((value) {
        setState(() {
          saleList = value;
        });
      });
    } else {
      await SearchController().getSales(widget.text!).then((value) {
        setState(() {
          saleList = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return saleList != null
        ? RefreshIndicator(
            onRefresh: setData,
            child: saleList!.isEmpty
                ? const CustomScrollView(
                    slivers: <Widget>[
                      SliverFillRemaining(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(150, 20, 0, 0),
                          child: Text("ไม่มีการขาย",
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  )
                : Container(
                    color: const Color(0xfff5f3e8),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        itemCount: saleList!.length,
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BuyPage(
                                            saleInfo: saleList![index])),
                                  ),
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                          height: 200,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              saleList![index]['image'],
                                            ),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    saleList![index]['book']
                                                        ['title'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 18)),
                                                Text(
                                                  '${saleList![index]['sellingPrice']}฿',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.red),
                                                ),
                                              ]))
                                    ],
                                  ),
                                ),
                              ));
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2.0,
                          mainAxisExtent: 290,
                        ),
                      ),
                    )),
          )
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

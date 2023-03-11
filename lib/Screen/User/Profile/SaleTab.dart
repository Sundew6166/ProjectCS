import 'package:flutter/material.dart';
import 'package:my_book/Screen/User/Hub/BuyPage.dart';
import 'package:my_book/Service/SaleController.dart';

class SaleTab extends StatefulWidget {
  const SaleTab({super.key});

  @override
  State<SaleTab> createState() => _SaleTabState();
}

class _SaleTabState extends State<SaleTab> {
  List<Map<String,dynamic>?> saleList = [];

  @override
  void initState() {
    setSaleList();
    super.initState();
  }

  setSaleList() async {
    await SaleController().getMySale().then((value) {
      setState(() {
        saleList.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: Color(0xfff5f3e8),
      child: ListView.builder(
        // padding: const EdgeInsets.all(5),
        itemCount: saleList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuyPage(saleInfo: saleList[index]!)),
                  ),
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
                                  child: Image.network(saleList[index]!['image']),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(saleList[index]!['book']['title'],
                                                style: TextStyle(fontSize: 18)),
                                            Expanded(
                                                child: Text(
                                              saleList[index]!['book']['isbn'],
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                          ])),
                                ),
                                Text(saleList[index]!['createDateTime'], textAlign: TextAlign.right),
                              ])))));
        },
      ),
    ));
  }
}

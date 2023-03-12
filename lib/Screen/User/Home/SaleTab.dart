import 'package:flutter/material.dart';

import 'package:my_book/Screen/User/Hub/BuyPage.dart';

class SaleTab extends StatefulWidget {
  SaleTab({super.key, required this.sales});
  List<dynamic> sales;

  @override
  State<SaleTab> createState() => _SaleTabState();
}

class _SaleTabState extends State<SaleTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.sales.isEmpty
            ? const Center(
                child: Text("ไม่มีการขาย", style: TextStyle(fontSize: 18)))
            : Container(
                color: const Color(0xfff5f3e8),
                child: BookCard(saleList: widget.sales)));
  }
}

class BookCard extends StatelessWidget {
  BookCard({super.key, required this.saleList});
  List<dynamic>? saleList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                        builder: (context) =>
                            BuyPage(saleInfo: saleList![index])),
                  ),
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: 200,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10), // Image border
                            child: Image.network(
                              saleList![index]['image'],
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(2),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(saleList![index]['book']['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 5),
                                Text(
                                  '${saleList![index]['sellingPrice']}฿',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                              ]))
                    ],
                  ),
                ),
              ));
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

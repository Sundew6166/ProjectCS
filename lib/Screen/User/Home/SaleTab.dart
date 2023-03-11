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
    await SaleController().getAllSale().then((value) {
      setState(() {
        saleList.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: saleList == [] ? Text("ยังไม่มีการขาย") : Container(color: Color(0xfff5f3e8), child: BookCard(saleList: saleList)));
  }
}

class BookCard extends StatelessWidget {
  BookCard({super.key, required this.saleList});
  List<Map<String,dynamic>?> saleList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemCount: saleList.length,
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellPage(saleInfo: saleList[index]!)),
                  ),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Expanded(
                      //   child: Image.asset(
                      //     "images/Conan.jpg",
                      //     fit: BoxFit.fill,
                      //   ),
                      // ),
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Image border
                        child: Image.network(
                          saleList[index]!['image'],
                          fit: BoxFit.fill,
                        ),
                      )),
                      Padding(
                          padding: EdgeInsets.all(2),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(saleList[index]!['book']['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${saleList[index]!['sellingPrice']}฿',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red),
                                ),
                              ]))
                    ],
                  ),
                ),
              ));
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.0,
          mainAxisExtent: 290,
        ),
      ),
    );
  }
}

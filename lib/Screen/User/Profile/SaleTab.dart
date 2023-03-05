import 'package:flutter/material.dart';
import 'package:my_book/Screen/User/Hub/BuyPage.dart';

class SaleTab extends StatefulWidget {
  const SaleTab({super.key});

  @override
  State<SaleTab> createState() => _SaleTabState();
}

class _SaleTabState extends State<SaleTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: Color(0xfff5f3e8),
      child: new ListView.builder(
        // padding: const EdgeInsets.all(5),
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SellPage()),
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
                                  child: Image.asset('images/Conan.jpg'),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("ชื่อหนังสือ",
                                                style: TextStyle(fontSize: 18)),
                                            Expanded(
                                                child: Text(
                                              "ISBN",
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                          ])),
                                ),
                                Text("03.03.2020"),
                              ])))));
        },
      ),
    ));
  }
}

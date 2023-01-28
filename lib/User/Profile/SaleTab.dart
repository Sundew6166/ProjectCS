import 'package:flutter/material.dart';

class SaleTab extends StatefulWidget {
  const SaleTab({super.key});

  @override
  State<SaleTab> createState() => _SaleTabState();
}

class _SaleTabState extends State<SaleTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView.builder(
        padding: const EdgeInsets.all(5),
        itemBuilder: (context, i) {
          return Container(
              height: 100,
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('images/Conan.jpg'),
                            Expanded(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("ชื่อหนังสือ",
                                            style: TextStyle(fontSize: 18)),
                                        Expanded(
                                            child: Text(
                                          "ราคา",
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ])),
                            ),
                            Text("03.03.2020"),
                          ]))));
        },
      ),
    );
  }
}

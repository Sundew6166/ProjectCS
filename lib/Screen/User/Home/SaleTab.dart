import 'package:flutter/material.dart';
import 'package:my_book/Screen/User/Profile/ChangePasswordPage.dart';
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
        body: Container(color: Color(0xfff5f3e8), child: BookCard()));
  }
}

class BookCard extends StatelessWidget {
  const BookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemCount: 6,
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellPage()),
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
                        child: Image.asset(
                          'images/Conan.jpg',
                          fit: BoxFit.fill,
                        ),
                      )),
                      Padding(
                          padding: EdgeInsets.all(2),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ชื่อหนังสือขาย",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '200฿',
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

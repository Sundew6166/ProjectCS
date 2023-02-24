import 'package:flutter/material.dart';
import 'package:my_book/User/Profile/ChangePasswordPage.dart';
import 'package:my_book/User/Hub/ReviewPage.dart';


class StockTab extends StatefulWidget {
  const StockTab({super.key});

  @override
  State<StockTab> createState() => _StockTabState();
}

class _StockTabState extends State<StockTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Color(0xfff5f3e8),
          child: new ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: 5,
            itemBuilder: (context, i) {
              return GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewPage()),
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
                                      borderRadius: BorderRadius.circular(
                                          5), // Image border
                                      child: Image.asset('images/Conan.jpg'),
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("ชื่อหนังสือ",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                Expanded(
                                                    child: Text(
                                                  "ISBN",
                                                  overflow:
                                                      TextOverflow.ellipsis,
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

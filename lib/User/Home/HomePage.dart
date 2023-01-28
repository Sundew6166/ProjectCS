import 'package:flutter/material.dart';
import 'package:my_book/User/Home/PostTab.dart';
import 'package:my_book/User/Home/SaleTab.dart';
import 'package:my_book/User/Home/SearchPage.dart';
import 'package:my_book/User/Home/NotiPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "My Book",
          ),
          leading: Image.asset("images/book-icon.png"),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
          ],
          bottom: new TabBar(tabs: [
            Tab(
              text: 'โพสต์',
            ),
            Tab(
              text: 'ขาย',
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            PostTab(),
            SaleTab(),
          ],
        ),
      ));
}

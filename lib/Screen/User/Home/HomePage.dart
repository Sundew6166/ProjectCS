import 'package:flutter/material.dart';
import 'package:my_book/Screen/User/Home/RecPostTab.dart';
import 'package:my_book/Screen/User/Home/SaleTab.dart';
import 'package:my_book/Screen/User/Home/SearchPage.dart';
import 'package:my_book/Screen/User/Home/NotiPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text(
            "My Book",
          ),
          // leading: Image.asset("images/logo.PNG"),
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
            RecPostTab(),
            SaleTab(),
          ],
        ),
      )));
}

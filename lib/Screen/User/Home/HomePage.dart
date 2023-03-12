import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Home/RecPostTab.dart';
import 'package:my_book/Screen/User/Home/SaleTab.dart';
import 'package:my_book/Screen/User/Home/SearchPage.dart';
import 'package:my_book/Screen/User/Home/NotiPage.dart';

import 'package:my_book/Service/PostController.dart';
import 'package:my_book/Service/SaleController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>? sales;
  List<dynamic>? posts;

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
    await PostController().getPostAll().then((value) {
      setState(() {
        posts = value;
      });
    });
    await SaleController().getAllSale().then((value) {
      setState(() {
        sales = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: WillPopScope(
          onWillPop: () async => false,
          child: sales != null
              ? Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: const Text("My Book"),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotificationPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchPage()),
                          );
                        },
                      ),
                    ],
                    bottom: const TabBar(tabs: [
                      Tab(text: 'โพสต์'),
                      Tab(text: 'ขาย'),
                    ]),
                  ),
                  body: TabBarView(
                    children: [
                      RecPostTab(posts: posts!),
                      SaleTab(sales: sales!),
                    ],
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Center(
                    child: Lottie.network(
                        'https://assets10.lottiefiles.com/packages/lf20_0M2ci9pi4Y.json'),
                  ),
                )));
}

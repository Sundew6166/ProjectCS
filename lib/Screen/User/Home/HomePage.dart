import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Home/RecPostTab.dart';
import 'package:my_book/Screen/User/Home/SaleTab.dart';
import 'package:my_book/Screen/User/Home/SearchPage.dart';
import 'package:my_book/Screen/User/Home/NotiPage.dart';
import 'package:my_book/Service/NotificationController.dart';

import 'package:my_book/Service/PostController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>? postList;
  List<dynamic>? notiList;

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
    await PostController().getPostAll().then((value) {
      setState(() {
        postList = value;
      });
    });
    // await NotificationController().getNotification().then((value) {
    //   setState(() {
    //     notiList = value;
    //   });
    // });
    // print(notiList);
  }

  var presscount = 0;

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: WillPopScope(
          onWillPop: () async {
            presscount++;
            if (presscount == 2) {
              exit(0);
            } else {
              var snackBar =
                  const SnackBar(content: Text('กดอีกครั้งเพื่อออกจากแอพ'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return false;
            }
          },
          child: postList != null 
              ? Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: const Text("My Book"),
                    actions: [
                      Badge(
                          // isLabelVisible: notiList!.isNotEmpty ? true : false,
                          smallSize: 10,
                          child: IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationPage()),
                              );
                            },
                          )),
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
                      Tab(text: 'ซื้อ'),
                    ]),
                  ),
                  body: TabBarView(
                    children: [
                      RecPostTab(posts: postList!),
                      SaleTab(page: 'home'),
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

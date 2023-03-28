import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_book/Screen/User/Profile/SaleList.dart';

import 'package:my_book/Screen/User/Profile/SettingPage.dart';
import 'package:my_book/Screen/User/Profile/StockTab.dart';
import 'package:my_book/Screen/User/Profile/PostTab.dart';
import 'package:my_book/Service/BookController.dart';

import 'package:my_book/Service/PostController.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  List<dynamic>? postList;
  List<dynamic>? bookList;

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
    await BookController().getAllBookInLibrary('USER').then((value) {
      setState(() {
        bookList = value;
      });
    });
    await PostController().getMyPost().then((value) {
      setState(() {
        postList = value;
      });
    });
  }
    Widget profile() {
    return SizedBox(
        height: 120,
        child: Column(
          children: [
            const SizedBox(height: 5),
            Center(
                child: CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL.toString()),
              backgroundColor: const Color(0xffadd1dc),
              radius: 40,
            )),
            const SizedBox(height: 5),
            Center(
                child: Text(
              user!.displayName.toString(),
              style: const TextStyle(fontSize: 18),
            )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return WillPopScope(
        onWillPop: () async => false,
        child: postList != null && bookList != null
            ? Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: const Text("My Book"),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SettingPage()))
                            .then((_) {
                          setState(() {
                            user = FirebaseAuth.instance.currentUser;
                          });
                        });
                      },
                    ),
                  ],
                ),
                body: Container(
                    color: const Color(0xfff5f3e8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          profile(),
                          SizedBox(
                            height: 35,
                            child: TabBar(
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(0xff795e35)),
                                labelColor: const Color(0xfff0dfa0),
                                unselectedLabelColor: const Color(0xffadd1dc),
                                controller: tabController,
                                tabs: const [
                                  Tab(icon: Icon(Icons.book, size: 30)),
                                  Tab(icon: Icon(Icons.message, size: 30)),
                                  Tab(icon: Icon(Icons.shopping_cart, size: 30))
                                ]),
                          ),
                          Container(
                            color: const Color(0xfff5f3e8),
                            height: MediaQuery.of(context).size.height - 266,
                            child: TabBarView(
                                controller: tabController,
                                children: [
                                  StockTab(
                                    accType: "USER",
                                    bookList: bookList!,
                                  ),
                                  PostTab(posts: postList!),
                                  const SaleList()
                                ]),
                          ),
                        ],
                      ),
                    )))
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Center(
                  child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_0M2ci9pi4Y.json'),
                ),
              ));
  }
}

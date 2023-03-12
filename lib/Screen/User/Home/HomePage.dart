import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
      child: new WillPopScope(
          onWillPop: () async => false,
          child: sales != null
              ? Scaffold(
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
                            MaterialPageRoute(
                                builder: (context) => const SearchPage()),
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
                      RecPostTab(posts: posts!),
                      SaleTab(sales: sales!),
                    ],
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color(0xfff5f3e8),
                  child: Center(
                    child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: const Color(0xFF1A1A3F),
                      rightDotColor: const Color(0xFFEA3799),
                      size: 50,
                    ),
                  ),
                )));
}

import 'package:flutter/material.dart';
import 'package:my_book/User/Profile/SettingPage.dart';
import 'package:my_book/User/Profile/StockTab.dart';
import 'package:my_book/User/Profile/SaleTab.dart';
import 'package:my_book/User/Profile/PostTab.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "My Book",
        ),
        // leading: Image.asset("images/logo.PNG"),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: CircleAvatar(
              backgroundImage: const AssetImage("images/rambo.jpg"),
              backgroundColor: Color(0xffadd1dc),
              radius: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Username 20 char (max)",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 35,
            child: TabBar(
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Creates border
                    color: Color(0xff795e35)),
                labelColor: Color(0xfff0dfa0),
                unselectedLabelColor: Color(0xffadd1dc),
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.book_outlined,
                      size: 30,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.message_outlined,
                      size: 30,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                    ),
                  )
                ]),
          ),
          Container(
            width: double.maxFinite,
            height: 485,
            child: TabBarView(controller: _tabController, children: [
              // Text('stock'),
              StockTab(),
              // Text('post'),
              PostTab(),
              // Text('sell'),
              SaleTab(),
            ]),
          ),
        ],
      ),
    );
  }
}

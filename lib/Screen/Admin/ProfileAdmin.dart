import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:my_book/Screen/Admin/SettingAdmin.dart';
import 'package:my_book/Screen/User/Profile/StockTab.dart';
import 'package:my_book/Screen/User/Profile/PostTab.dart';
import 'package:my_book/Screen/Admin/ApproveTab.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Text(
                "My Book",
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingAdmin()),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: Container(
              color: Color(0xfff5f3e8),
              child: Column(
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
                      user!.displayName.toString(),
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
                            borderRadius:
                                BorderRadius.circular(50), // Creates border
                            color: Color(0xff795e35)),
                        labelColor: Color(0xfff0dfa0),
                        unselectedLabelColor: Color(0xffadd1dc),
                        controller: _tabController,
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.book,
                              size: 30,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.message,
                              size: 30,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.check_circle,
                              size: 30,
                            ),
                          )
                        ]),
                  ),
                  Container(
                    color: Color(0xfff5f3e8),
                    // width: double.maxFinite,
                    // height: 480,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(controller: _tabController, children: [
                      StockTab(),
                      PostTab(),
                      ApproveTab(),
                    ]),
                  ),
                ],
              ),
            ))));
  }
}

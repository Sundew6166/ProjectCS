import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:my_book/Screen/User/Hub/Social.dart';
import 'package:my_book/Screen/User/Home/PostPage.dart';

import 'package:my_book/Screen/User/Hub/AddBook.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Text(
                "My Book",
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: Container(
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    color: Color(0xfff5f3e8),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        PostSection(),
                      ],
                    ))),
            floatingActionButton:
                SpeedDial(child: Icon(Icons.more_vert), children: [
              SpeedDialChild(
                child: Icon(
                  Icons.add,
                  color: Color(0xff795e35),
                  size: 35,
                ),
                label: 'สร้างโพสต์',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostPage()),
                ),
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.book,
                  color: Color(0xff795e35),
                  size: 35,
                ),
                label: 'เพิ่มหนังสือใหม่',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddBook(
                            isbn: '',
                          )),
                ),
              ),
            ])));
  }
}

class PostSection extends StatefulWidget {
  const PostSection({super.key});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xfff5f3e8),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        // width: 280,
        child: ListView.builder(
          itemCount: 25,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return GestureDetector(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SocialPage()),
                    ),
                child: Container(
                    height: 90,
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(7),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        const AssetImage("images/rambo.jpg"),
                                    backgroundColor: Color(0xffadd1dc),
                                    radius: 30,
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("ชื่อคนอื่น",
                                                  maxLines: 1,
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              Text(
                                                "รายละเอียดโพสต์",
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ])),
                                  ),
                                  Text("03.03.2020"),
                                ])))));
          },
        ));
  }
}

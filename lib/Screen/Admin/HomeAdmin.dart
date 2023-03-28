import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Hub/Social.dart';
import 'package:my_book/Screen/User/Home/PostPage.dart';
import 'package:my_book/Screen/User/Hub/AddBook.dart';

import 'package:my_book/Service/PostController.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<dynamic>? posts;
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    setPosts();
    super.initState();
  }

  Future<void> setPosts() async {
    await PostController().getPostAll().then((value) {
      setState(() {
        posts = value;
      });
    });
  }

  var presscount = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
        child: posts != null
            ? Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: const Text("My Book"),
                ),
                body: Container(
                    color: const Color(0xfff5f3e8),
                    height: MediaQuery.of(context).size.height,
                    child: RefreshIndicator(
                      onRefresh: setPosts,
                      child: posts!.isEmpty
                          ? const CustomScrollView(
                              slivers: <Widget>[
                                SliverFillRemaining(
                                  child: Center(
                                    child: Text("ไม่มีโพสต์",
                                        style: TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ],
                            )
                          : PostSec(posts: posts!),
                    )),
                floatingActionButton: SpeedDial(children: [
                  SpeedDialChild(
                    child: const Icon(
                      Icons.add,
                      color: Color(0xff795e35),
                      size: 35,
                    ),
                    label: 'สร้างโพสต์',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostPage()),
                    ),
                  ),
                  SpeedDialChild(
                    child: const Icon(
                      Icons.book,
                      color: Color(0xff795e35),
                      size: 35,
                    ),
                    label: 'เพิ่มหนังสือใหม่',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddBook(accType: "ADMIN")),
                    ),
                  ),
                ], child: const Icon(Icons.more_vert)))
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Center(
                    child: Lottie.network(
                        'https://assets10.lottiefiles.com/packages/lf20_0M2ci9pi4Y.json')),
              ));
  }
}

class PostSec extends StatefulWidget {
  PostSec({Key? key, required this.posts}) : super(key: key);

  List<dynamic> posts;

  @override
  State<PostSec> createState() => _PostSecState();
}

class _PostSecState extends State<PostSec> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: widget.posts.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return GestureDetector(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SocialPage(posts: widget.posts[i])),
                    ),
                child: SizedBox(
                    height: 90,
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        '${widget.posts[i]['Image']}'),
                                    backgroundColor: const Color(0xffadd1dc),
                                    radius: 30,
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${widget.posts[i]['CreateBy']}',
                                                  style: const TextStyle(
                                                      fontSize: 18)),
                                              Text(
                                                '${widget.posts[i]['Detail_Post']}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ])),
                                  ),
                                  Text(
                                      '${widget.posts[i]['Create_DateTime_Post']}',
                                      textAlign: TextAlign.right),
                                ])))));
          },
        ));
  }
}

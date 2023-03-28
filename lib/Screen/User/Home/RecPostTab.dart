import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Home/PostPage.dart';
import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Screen/User/Hub/Social.dart';
import 'package:my_book/Service/PostController.dart';

class RecPostTab extends StatefulWidget {
  RecPostTab({super.key, required this.posts});
  List<dynamic>? posts;

  @override
  State<RecPostTab> createState() => _RecPostTabState();
}

class _RecPostTabState extends State<RecPostTab> {
  @override
  void initState() {
    super.initState();
    reFresh();
  }

  Future<void> reFresh() async {
    await PostController().getPostAll().then((value) {
      setState(() {
        widget.posts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.posts != null
        ? Scaffold(
            body: RefreshIndicator(
                onRefresh: reFresh,
                child: Container(
                    color: const Color(0xfff5f3e8),
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            const RecommendSection(),
                            PostSection(posts: widget.posts!),
                          ],
                        )))),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xff795e35),
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostPage()),
                );
              },
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
                child: Lottie.network(
                    'https://assets1.lottiefiles.com/packages/lf20_yyytgjwe.json')),
          );
  }
}

class RecommendSection extends StatelessWidget {
  const RecommendSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "แนะนำสำหรับคุณ",
          style: TextStyle(fontSize: 25),
        ),
        const SizedBox(height: 5),
        Container(
            height: 180,
            width: 400,
            color: const Color(0xffadd1dc),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  children: const [
                    RecommendCard(),
                    RecommendCard(),
                    RecommendCard(),
                    RecommendCard(),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  children: const [
                    RecommendCard(),
                    RecommendCard(),
                    RecommendCard(),
                    RecommendCard(),
                  ],
                )
              ]),
            )),
      ],
    );
  }
}

class RecommendCard extends StatelessWidget {
  const RecommendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReviewPage(bookInfo: {}, hasBook: false, hasSale: false)),
            ),
        child: SizedBox(
            height: 90,
            width: 220,
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(5), // Image border
                            child: Image.asset('images/Conan.jpg'),
                          ),
                          Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text("ชื่อหนังสือ",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 18)),
                                      Expanded(
                                          child: Text(
                                        "ชื่อผู้แต่ง",
                                        overflow: TextOverflow.ellipsis,
                                      ))
                                    ])),
                          ),
                          // Text("03.03.2002"),
                        ])))));
  }
}

class PostSection extends StatefulWidget {
  PostSection({Key? key, required this.posts}) : super(key: key);
  List<dynamic> posts;

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xfff5f3e8),
        height: MediaQuery.of(context).size.height,
        child: widget.posts.isEmpty
            ? Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: const Text("ไม่มีโพสต์", style: TextStyle(fontSize: 18)))
            : ListView.builder(
                itemCount: widget.posts.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return GestureDetector(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SocialPage(posts: widget.posts[i]),
                            ),
                          ),
                      child: SizedBox(
                          height: 90,
                          child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              '${widget.posts[i]['Image']}'),
                                          backgroundColor:
                                              const Color(0xffadd1dc),
                                          radius: 30,
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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

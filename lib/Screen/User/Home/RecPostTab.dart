import 'package:flutter/material.dart';

// screen
import 'package:my_book/Screen/User/Home/PostPage.dart';
import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Screen/User/Hub/Social.dart';

class PostTab extends StatefulWidget {
  const PostTab({super.key});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  late Map<String, dynamic> dataPost;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Container(
              color: Color(0xfff5f3e8),
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  RecommendSection(),
                  PostSection(),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff795e35),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostPage()),
          );
        },
      ),
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
        Container(
          child: Text(
            "แนะนำสำหรับคุณ",
            style: TextStyle(
                // color: const Color(0xff795e35),
                fontSize: 25),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
            height: 180,
            width: 400,
            color: Color(0xffadd1dc),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    RecommendCard(),
                    RecommendCard(),
                    RecommendCard(),
                    RecommendCard(),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
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
              MaterialPageRoute(builder: (context) => ReviewPage()),
            ),
        child: Container(
            height: 90,
            width: 220,
            child: Card(
                child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image.asset('images/Conan.jpg'),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(5), // Image border
                            child: Image.asset('images/Conan.jpg'),
                          ),
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
  const PostSection({super.key});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff5f3e8),
      // height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        // width: 280,
        child: ListView.builder(
          itemCount: 5,
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

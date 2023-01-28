import 'package:flutter/material.dart';
import 'package:my_book/User/Home/PostPage.dart';

class PostTab extends StatefulWidget {
  const PostTab({super.key});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  recommendSection(),
                  Container(
                      height: 100,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [],
                          )))
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

class recommendSection extends StatelessWidget {
  const recommendSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            "แนะนำสำหรับคุณ",
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
            height: 180,
            color: Color(0xfff0dfa0),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        RecommendCard(),
                        RecommendCard(),
                        RecommendCard(),
                        RecommendCard()
                      ],
                    ),
                    Row(
                      children: [
                        RecommendCard(),
                        RecommendCard(),
                        RecommendCard(),
                        RecommendCard()
                      ],
                    )
                  ],
                ))),
        Container(
          height: 370,
          // color: Colors.blue,
          child: PostSection(),
        )
      ],
    );
  }
}

class RecommendCard extends StatelessWidget {
  const RecommendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        width: 220,
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(7),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('images/Conan.jpg'),
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                    ]))));
  }
}

class PostSection extends StatelessWidget {
  const PostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: const EdgeInsets.all(5),
      itemBuilder: (context, i) {
        return Container(
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
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Username",
                                          style: TextStyle(fontSize: 18)),
                                      Text(
                                        "รายละเอียดโพสต์",
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ])),
                          ),
                          Text("03.03.2020"),
                        ]))));
      },
    );
  }
}

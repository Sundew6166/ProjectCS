import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// screen
import 'package:my_book/Screen/User/Home/PostPage.dart';
import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Screen/User/Hub/Social.dart';
import 'package:my_book/Service/PostController.dart';

class RecPostTab extends StatefulWidget {
  const RecPostTab({super.key});

  @override
  State<RecPostTab> createState() => _RecPostTabState();
}

class _RecPostTabState extends State<RecPostTab> {
  List<dynamic>? posts;

  @override
  void initState() {
    setPosts();
    super.initState();
  }

  setPosts() async {
    await PostController().getPostAll().then((value) {
      setState(() {
        posts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return posts != null
        ? Scaffold(
            // resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: Container(
                    color: Color(0xfff5f3e8),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        RecommendSection(),
                        PostSection(
                          posts: posts!,
                        ),
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
              MaterialPageRoute(
                  builder: (context) => ReviewPage(bookInfo: {}, hasBook: false, hasSale: false)),
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
  // const PostSection({super.key});
  PostSection({Key? key, required this.posts}) : super(key: key);
  List<dynamic> posts;

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
          itemCount: widget.posts.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return GestureDetector(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SocialPage(posts: widget.posts[i],)),
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
                                    backgroundImage: NetworkImage(
                                        '${widget.posts[i]['Image']}'),
                                    backgroundColor: Color(0xffadd1dc),
                                    radius: 30,
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${widget.posts[i]['CreateBy']}',
                                                  style:
                                                      TextStyle(fontSize: 18)),
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

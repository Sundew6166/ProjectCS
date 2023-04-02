import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Home/PostPage.dart';
import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Screen/User/Hub/Social.dart';
import 'package:my_book/Service/PostController.dart';
import 'package:my_book/Service/Recommendation.dart';

class RecPostTab extends StatefulWidget {
  const RecPostTab({super.key});

  @override
  State<RecPostTab> createState() => _RecPostTabState();
}

class _RecPostTabState extends State<RecPostTab> {
  List<dynamic>? postList;
  List<dynamic>? recommendList;
  @override
  void initState() {
    super.initState();
    reFresh();
  }

  Future<void> reFresh() async {
    await PostController().getPostAll().then((value) {
      setState(() {
        postList = value;
      });
    });
    await Recommendation().getRecommend().then((value) {
      setState(() {
        recommendList = value;
      });
    });
    // print(recommendList);
  }

  @override
  Widget build(BuildContext context) {
    return postList != null && recommendList != null
        ? Scaffold(
            body: RefreshIndicator(
                onRefresh: reFresh,
                child: Container(
                    color: const Color(0xfff5f3e8),
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            RecommendSection(recommendList: recommendList!,),
                            PostSection(postList: postList!),
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
  RecommendSection({Key? key, required this.recommendList}) : super(key: key);
  List<dynamic> recommendList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "แนะนำสำหรับคุณ",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 5),
        Container(
          height: 220,
          width: 400,
          color: const Color(0xffadd1dc),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendList.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return RecommendCard(recommendList: recommendList[i],);
              }),
        )
      ],
    );
  }
}

class RecommendCard extends StatelessWidget {
RecommendCard({Key? key, required this.recommendList}) : super(key: key);
  var recommendList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReviewPage(
                      bookInfo: const {}, hasBook: false, hasSale: false)),
            ),
        child: SizedBox(
          height: 200,
          width: 150,
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(recommendList['coverImage']),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(1),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                recommendList['title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14)),
                            Text(
                              recommendList['author'],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ]))
                ],
              ),
            ),
          ),
        ));
  }
}

class PostSection extends StatefulWidget {
  PostSection({Key? key, required this.postList}) : super(key: key);
  List<dynamic> postList;

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.postList.length < 4 ? 400 : widget.postList.length * 90,
        child: widget.postList.isEmpty
            ? Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: const Text("ไม่มีโพสต์", style: TextStyle(fontSize: 18)))
            : ListView.builder(
                itemCount: widget.postList.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return GestureDetector(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SocialPage(posts: widget.postList[i]),
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
                                              '${widget.postList[i]['Image']}'),
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
                                                        '${widget.postList[i]['CreateBy']}',
                                                        style: const TextStyle(
                                                            fontSize: 18)),
                                                    Text(
                                                      '${widget.postList[i]['Detail_Post']}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  ])),
                                        ),
                                        Text(
                                            '${widget.postList[i]['Create_DateTime_Post']}',
                                            textAlign: TextAlign.right),
                                      ])))));
                },
              ));
  }
}

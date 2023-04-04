import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Hub/Social.dart';
import 'package:my_book/Service/PostController.dart';
import 'package:my_book/Service/SearchController.dart';

class PostTab extends StatefulWidget {
  PostTab({Key? key, required this.page, this.text}) : super(key: key);
  String? page;
  String? text;

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  List<dynamic>? postList;
  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
    if (widget.page == 'search') {
      await SearchController().getPosts(widget.text!).then((value) {
        setState(() {
          postList = value;
        });
      });
    } else {
      await PostController().getMyPost().then((value) {
        setState(() {
          postList = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return postList != null
        ? Container(
            child: postList!.isEmpty
                ? Container(
                    padding: const EdgeInsets.fromLTRB(150, 20, 0, 0),
                    child: const Text("ไม่มีโพสต์",
                        style: TextStyle(fontSize: 18)))
                : Container(
                    color: const Color(0xfff5f3e8),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: postList!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SocialPage(
                                            posts: postList![i],
                                          )),
                                ),
                            child: SizedBox(
                                height: 100,
                                child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    '${postList![i]['Image']}'),
                                                backgroundColor:
                                                    const Color(0xffadd1dc),
                                                radius: 30,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              '${postList![i]['CreateBy']}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                          Text(
                                                            '${postList![i]['Detail_Post']}',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )
                                                        ])),
                                              ),
                                              Text(
                                                  '${postList![i]['Create_DateTime_Post']}',
                                                  textAlign: TextAlign.right),
                                            ])))));
                      },
                    ),
                  ))
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xfff5f3e8),
            child: Center(
              child: Lottie.network(
                  'https://assets1.lottiefiles.com/packages/lf20_yyytgjwe.json'),
            ),
          );
  }
}

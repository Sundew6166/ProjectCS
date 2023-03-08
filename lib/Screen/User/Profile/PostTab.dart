import 'package:flutter/material.dart';

// import 'package:my_book/Service/PostController.dart';
import 'package:my_book/Screen/User/Hub/Social.dart';

class PostTab extends StatefulWidget {
  // const PostTab({super.key});
  PostTab({Key? key, required this.posts}) : super(key: key);
  List<dynamic>? posts;

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: Color(0xfff5f3e8),
      child: new ListView.builder(
        // padding: const EdgeInsets.all(5),
        itemCount: widget.posts!.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SocialPage()),
                  ),
              child: Container(
                  height: 100,
                  child: Card(
                      child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '${widget.posts![i]['Image']}'),
                                  backgroundColor: Color(0xffadd1dc),
                                  radius: 30,
                                ),
                                Expanded(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${widget.posts![i]['CreateBy']}',
                                                style: TextStyle(fontSize: 18)),
                                            // Expanded(
                                            //     child:
                                            Text(
                                              '${widget.posts![i]['Detail_Post']}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                            // )
                                          ])),
                                ),
                                Text(
                                    '${widget.posts![i]['Create_DateTime_Post']}',
                                    textAlign: TextAlign.right),
                              ])))));
        },
      ),
    ));
  }
}

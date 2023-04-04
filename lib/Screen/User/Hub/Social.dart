import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_book/Service/PostController.dart';

class SocialPage extends StatefulWidget {
  SocialPage({Key? key, required this.posts}) : super(key: key);

  Map<String, dynamic>? posts;

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final user = FirebaseAuth.instance.currentUser;
  List<dynamic>? comments;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    setData();
    super.initState();
  }

  Future<void> setData() async {
    await PostController().getComment(widget.posts!['ID']).then((value) {
      setState(() {
        comments = value;
      });
    });
  }

  Widget commentChild(data) {
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 0.0),
            child: Card(
                color: const Color.fromARGB(255, 231, 244, 248),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundImage:
                                  NetworkImage('${widget.posts!['Image']}'),
                              backgroundColor: const Color(0xffadd1dc),
                              radius: 20),
                          Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('\t${widget.posts!['CreateBy']}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16)),
                                    ])),
                          ),
                          Text("${widget.posts!['Create_DateTime_Post']}",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right),
                        ],
                      ),
                      Text('\t${widget.posts!['Detail_Post']}',
                          style: const TextStyle(fontSize: 16)),
                    ])))),
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: NetworkImage(data[i]['Image']))),
                ),
              ),
              title: Text(data[i]['CreateBy'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(data[i]['Detail_Comment']),
              trailing: Text(data[i]['Create_DateTime_Comment'],
                  style: const TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("โซเชียล"),
          backgroundColor: const Color(0xff795e35),
        ),
        body: comments != null
            ? RefreshIndicator(
                onRefresh: setData,
                child: CommentBox(
                  userImage: CommentBox.commentImageParser(
                    imageURLorPath: NetworkImage(user!.photoURL.toString()),
                  ),
                  labelText: 'เขียนแสดงความคิดเห็น...',
                  errorText: 'ข้อมูลไม่ถูกต้อง',
                  withBorder: true,
                  sendButtonMethod: () async {
                    if (commentController.text.isNotEmpty) {
                      try {
                        await PostController()
                            .addComment(
                                commentController.text, widget.posts!['ID'])
                            .then((value) => Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation1,
                                        Animation<double> animation2) {
                                      return super.widget;
                                    },
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                ));
                      } on FirebaseException catch (e) {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                    title: Text(e.message.toString()),
                                    content: const Text(
                                        "เกิดข้อผิดพลาดในการส่งข้อมูล กรุณาลองใหม่"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('ตกลง'),
                                      )
                                    ]));
                      }

                      commentController.clear();
                      FocusScope.of(context).unfocus();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('กรุณาแสดงความเห็น',
                                style: TextStyle(fontSize: 18)),
                            backgroundColor: Colors.red),
                      );
                    }
                  },
                  commentController: commentController,
                  backgroundColor: const Color(0xff795e35),
                  textColor: Colors.white,
                  sendWidget: const Icon(Icons.send_sharp,
                      size: 30, color: Colors.white),
                  child: commentChild(comments),
                ))
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Center(
                  child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_0M2ci9pi4Y.json'),
                ),
              ));
  }
}

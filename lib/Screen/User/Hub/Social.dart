import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_book/Service/PostController.dart';

class SocialPage extends StatefulWidget {
  SocialPage({Key? key, required this.posts}) : super(key: key);

  Map<String, dynamic>? posts;

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  List<dynamic>? comments;
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
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
            // padding: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 0.0),
            child: Card(
                color: Color.fromARGB(255, 231, 244, 248),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage('${widget.posts!['Image']}'),
                            backgroundColor: Color(0xffadd1dc),
                            radius: 20,
                          ),
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('\t${widget.posts!['CreateBy']}',
                                          style: TextStyle(fontSize: 16)),
                                    ])),
                          ),
                          Text("${widget.posts!['Create_DateTime_Post']}",
                              textAlign: TextAlign.right),
                        ],
                      ),
                      Text('\t${widget.posts!['Rating']}',
                          style: TextStyle(fontSize: 16)),
                    ])))),
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                // onTap: () async {
                //   print("Comment Clicked");
                // },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: NetworkImage(data[i]['Image']))),
                ),
              ),
              title: Text(
                data[i]['CreateBy'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['Detail_Comment']),
              trailing: Text(data[i]['Create_DateTime_Comment'],
                  style: TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("โซเชียล"),
          backgroundColor: Color(0xff795e35),
        ),
        body: comments != null
            ? Container(
                child: CommentBox(
                  userImage: CommentBox.commentImageParser(
                    imageURLorPath: NetworkImage('${widget.posts!['Image']}'),
                  ),
                  child: commentChild(comments),
                  labelText: 'เขียนแสดงความคิดเห็น...',
                  errorText: 'ข้อมูลไม่ถูกต้อง',
                  withBorder: true,
                  sendButtonMethod: () {
                    if (formKey.currentState!.validate()) {
                      // print(commentController.text);
                      setState(() async {
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
                                    // MaterialPageRoute(
                                    //     builder: (BuildContext context) =>
                                    //         super.widget)
                                  ));
                        } on FirebaseException catch (e) {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                      title: Text(e.message.toString()),
                                      content: Text(
                                          "เกิดข้อผิดพลาดในการส่งข้อมูล กรุณาลองใหม่"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('ตกลง'),
                                        )
                                      ]));
                        }
                      });
                      commentController.clear();
                      FocusScope.of(context).unfocus();
                    } else {
                      print("Not validated");
                    }
                  },
                  formKey: formKey,
                  commentController: commentController,
                  backgroundColor: Color(0xff795e35),
                  textColor: Colors.white,
                  sendWidget:
                      Icon(Icons.send_sharp, size: 30, color: Colors.white),
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
              ));
  }
}

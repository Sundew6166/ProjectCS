import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'กิ่ง',
      'pic': 'images/ging.jpg',
      'message': 'อยากออกไปหาไรกิน',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'พะแนง',
      'pic': 'images/peang.jpg',
      'message': 'ราเมง',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'ยู',
      'pic': 'images/you.jpg',
      'message': 'ไปเซ็นทรัลเวิร์ล',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'ดิว',
      'pic': 'images/dew.jpg',
      'message': 'อยากกินส้มตำ',
      'date': '2021-01-01 12:00:00'
    },
  ];

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
                                const AssetImage("images/lina.jpg"),
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
                                      Text('\tลีน่า',
                                          style: TextStyle(fontSize: 16)),
                                    ])),
                          ),
                          Text("03.03.2002"),
                        ],
                      ),
                      Text(
                          '\เสาร์อาทิดนี้เริ่มทำapi ละก่อนหน้านี้ชดใช้กรรมกับงานนู้นอยู่ 5555 แล้วก็ติดต่อดี๋ยากมากก ',
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
                          imageURLorPath: data[i]['pic'])),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
              trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
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
      body: Container(
        child: CommentBox(
          userImage:
              CommentBox.commentImageParser(imageURLorPath: "images/lina.jpg"),
          child: commentChild(filedata),
          labelText: 'เขียนแสดงความคิดเห็น...',
          errorText: 'ข้อมูลไม่ถูกต้อง',
          withBorder: true,
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              print(commentController.text);
              setState(() {
                var value = {
                  'name': 'ลีน่า',
                  'pic': 'images/lina.jpg',
                  'message': commentController.text,
                  'date': '2021-01-01 12:00:00'
                };
                filedata.insert(0, value);
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
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}

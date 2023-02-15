import 'package:flutter/material.dart';

class PostTab extends StatefulWidget {
  const PostTab({super.key});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color(0xfff5f3e8),
      child: new ListView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: 5,
        itemBuilder: (context, i) {
          return Container(
              height: 100,
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
                                        // Expanded(
                                        //     child:
                                        Text(
                                          "รายละเอียดโพสต์",
                                          overflow: TextOverflow.ellipsis,
                                        )
                                        // )
                                      ])),
                            ),
                            Text("03.03.2020"),
                          ]))));
        },
      ),
    ));
  }
}

import 'package:flutter/material.dart';

import 'package:my_book/Screen/User/Profile/ChangePasswordPage.dart';

class PostSearch extends StatefulWidget {
  const PostSearch({super.key});

  @override
  State<PostSearch> createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      // padding: const EdgeInsets.all(5),
      itemCount: 5,
      itemBuilder: (context, i) {
        return GestureDetector(
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Username",
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 18)),
                                          Text(
                                            "รายละเอียดโพสต์",
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ])),
                              ),
                              Text("03.03.2020"),
                            ])))));
      },
    );
  }
}
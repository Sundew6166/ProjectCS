import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


import 'package:my_book/Screen/User/Home/BookSearch.dart';
import 'package:my_book/Screen/User/Home/RecPostTab.dart';

import 'package:my_book/Screen/User/Home/SaleTab.dart';
import 'package:my_book/Service/PostController.dart';

class TabSearch extends StatefulWidget {
  TabSearch({Key? key, required this.data}) : super(key: key);

  String data;

  @override
  State<TabSearch> createState() => _TabSearchState();
}

class _TabSearchState extends State<TabSearch> {
  TextEditingController _controller = TextEditingController();
  List<dynamic>? posts;

  @override
  void initState() {
    setPosts();
    super.initState();
    _controller = TextEditingController(text: widget.data);
    // print(widget.data);
  }

  setPosts() async {
    await PostController().getPostAll().then((value) {
      setState(() {
        posts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 3,
      child: posts != null
                    ? Scaffold(
        appBar: AppBar(
          title: Container(
            // width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                      },
                    ),
                    hintText: '\tค้นหา...',
                    border: InputBorder.none),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabSearch(data: _controller.text)),
                );
              },
            ),
          ],
          bottom: new TabBar(tabs: [
            Tab(
              text: 'หนังสือ',
            ),
            Tab(
              text: 'โพสต์',
            ),
            Tab(
              text: 'ซื้อ-ขาย',
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            BookSearch(),
            PostSection(
              posts: posts!,
            ),
            SaleTab(),
          ],
        ),
      ): Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black,
                        child: Center(
                          child: LoadingAnimationWidget.twistingDots(
                            leftDotColor: const Color(0xFF1A1A3F),
                            rightDotColor: const Color(0xFFEA3799),
                            size: 50,
                          ),
                        ),
                      ));
}

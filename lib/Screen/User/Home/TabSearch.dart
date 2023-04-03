import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:my_book/Screen/User/Home/BookSearch.dart';
import 'package:my_book/Screen/User/Home/SaleTab.dart';
import 'package:my_book/Screen/User/Profile/PostTab.dart';

class TabSearch extends StatefulWidget {
  TabSearch({Key? key, required this.data}) : super(key: key);

  String data;

  @override
  State<TabSearch> createState() => _TabSearchState();
}

class _TabSearchState extends State<TabSearch> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.data);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
                appBar: AppBar(
                  title: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
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
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.only(left: 3.0, top: 3.0)),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _controller.text.trim().isNotEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TabSearch(data: _controller.text),
                                ),
                              )
                            : Fluttertoast.showToast(
                                msg: "กรุณากรอกข้อมูลที่ต้องการค้นหา",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 18.0);
                      },
                    ),
                  ],
                  bottom: const TabBar(tabs: [
                    Tab(text: 'หนังสือ'),
                    Tab(text: 'โพสต์'),
                    Tab(text: 'การขาย'),
                  ]),
                ),
                body: TabBarView(
                  children: [
                    BookSearch(text: _controller.text),
                    PostTab(page: 'search', text: _controller.text),
                    SaleTab(page: 'search', text: _controller.text),
                  ],
                ),
              )
      );
}

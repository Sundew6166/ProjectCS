import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import 'package:my_book/Screen/User/Home/BookSearch.dart';
import 'package:my_book/Screen/User/Home/SaleTab.dart';
import 'package:my_book/Screen/User/Profile/PostTab.dart';

import 'package:my_book/Service/SearchController.dart';

class TabSearch extends StatefulWidget {
  TabSearch({Key? key, required this.data}) : super(key: key);

  String data;

  @override
  State<TabSearch> createState() => _TabSearchState();
}

class _TabSearchState extends State<TabSearch> {
  TextEditingController _controller = TextEditingController();
  List<dynamic>? posts;
  List<dynamic>? books;
  List<dynamic>? sales;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.data);
    setData();
  }

  setData() async {
    await SearchController().getSales(_controller.text).then((value) {
      setState(() {
        sales = value;
      });
    });
    await SearchController().getBooks(_controller.text).then((value) {
      setState(() {
        books = value;
      });
    });
    await SearchController().getPosts(_controller.text).then((value) {
      setState(() {
        posts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: posts != null && books != null && sales != null
            ? Scaffold(
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
                    Tab(text: 'ซื้อ'),
                  ]),
                ),
                body: TabBarView(
                  children: [
                    BookSearch(books: books!),
                    PostTab(posts: posts!),
                    SaleTab(sales: sales!, page: 'search',),
                  ],
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Center(
                  child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_0M2ci9pi4Y.json'),
                ),
              ),
      );
}

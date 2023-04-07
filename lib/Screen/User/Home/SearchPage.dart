import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_book/Screen/User/Home/TabSearch.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController data = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              controller: data,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    data.clear();
                  },
                ),
                hintText: "\tค้นหา...",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 3.0, top: 3.0)
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              data.text.trim().isNotEmpty
              ? Navigator.push(context, MaterialPageRoute(builder: (context) => TabSearch(data: data.text)))
              : Fluttertoast.showToast(
                  msg: "กรุณากรอกข้อมูลที่ต้องการค้นหา",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 18.0
                );
            },
          ),
        ]
      )
    );
  }
}

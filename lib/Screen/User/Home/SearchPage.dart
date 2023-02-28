import 'package:flutter/material.dart';

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
              // width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  controller: data,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          data.clear();
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
              print(data.text);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TabSearch(data: data.text)),
              );
              // print(data.text);
            },
          ),
        ]));
  }
}

import 'package:flutter/material.dart';
import 'package:my_book/User/Home/PostPage.dart';

class PostTab extends StatefulWidget {
  const PostTab({super.key});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ข้อมูลโพสต์จ้าาา')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff795e35),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostPage()),
          );
        },
      ),
    );
  }
}

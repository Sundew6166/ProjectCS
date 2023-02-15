import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('สร้างโพสต์'),
        ),
        body: Container(
          color: Color(0xfff5f3e8),
          child: Center(
            child: const Text('Go back!'),
          ),
        ));
  }
}


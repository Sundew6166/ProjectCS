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
      body: Center(
        // child: ElevatedButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        child: const Text('Go back!'),
        // ),
      ),
    );
  }
}
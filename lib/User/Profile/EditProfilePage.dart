import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController textarea = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('แก้ไขโปรไฟล์'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: textarea,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                decoration: InputDecoration(
                    hintText: "Write something here...",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: const Color(0xff795e35)))),
              ),
              ElevatedButton(
                  onPressed: () {
                    print(textarea.text);
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(400, 40), // specify width, height
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                        10,
                      ))),
                  child: Text("Post", style: TextStyle(fontSize: 20)))
            ],
          ),
        ));
  }
}

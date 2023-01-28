import 'package:flutter/material.dart';
import 'package:my_book/BottomBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomBar(),
      theme: ThemeData(colorSchemeSeed: const Color(0xff795e35)),
    );
  }
}

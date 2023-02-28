// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:my_book/BottomBar.dart';
// import 'package:my_book/LogInPage.dart';
import 'package:my_book/Screen/RegisterPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterScreen(),
      theme: ThemeData(colorSchemeSeed: const Color(0xff795e35)),
      // color: Color(0xffcaa171),
    );
  }
}

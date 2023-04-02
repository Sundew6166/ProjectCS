import 'package:firebase_core/firebase_core.dart';
import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Screen/LogInPage.dart';
import 'package:my_book/Service/AccountController.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

String type = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  type = await AccountController().getAccountType();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: type != "" ? BottomBar(accType: type, tab: "HOME") : const LogInPage(),
      theme: ThemeData(colorSchemeSeed: const Color(0xff795e35)),
    );
  }
}

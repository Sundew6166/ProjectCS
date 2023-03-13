import 'package:firebase_core/firebase_core.dart';
import 'package:my_book/Service/SaleController.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'package:my_book/Screen/RegisterPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true);
  runApp(MyApp());
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((taskName, inputData) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    switch (taskName) {
      case "paymentTimeout":
        print("paymentTimeout");
        await SaleController().paymentTimeout(inputData!['idSale']);
        break;
    }
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterScreen(),
      theme: ThemeData(colorSchemeSeed: const Color(0xff795e35)),
    );
  }
}

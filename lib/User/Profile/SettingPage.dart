import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่า'),
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

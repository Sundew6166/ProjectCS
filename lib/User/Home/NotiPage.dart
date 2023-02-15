import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('แจ้งเตือน'),
        ),
        body: Container(
          color: Color(0xfff5f3e8),
          child: Center(
            child: const Text('notification page'),
          ),
        ));
  }
}

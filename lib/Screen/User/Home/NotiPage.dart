import 'package:flutter/material.dart';

import 'package:my_book/Screen/User/Hub/PaymentPage.dart';

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
            color: const Color(0xfff5f3e8),
            child: ListView.builder(
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      // TODO: go to review page when noti of approve
                      // TODO: noti คนขายไปส่งของ
                      // TODO: go to payment page
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentPage()),
                          ),
                      child: SizedBox(
                          height: 100,
                          child: Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.circle_notifications,
                                size: 40,
                              ),
                              title: Text(
                                "แจ้งเตือน $index",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: const Text(
                                "\tรายละเอียดต่างๆ",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Text("เวลาที่ผ่านมา",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          )));
                })));
  }
}

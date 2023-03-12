import 'package:flutter/material.dart';

import 'package:my_book/Screen/User/Profile/ChangePasswordPage.dart';
import 'package:my_book/Screen/User/Profile/EditAddressPage.dart';
import 'package:my_book/Screen/User/Profile/EditProfilePage.dart';
import 'package:my_book/Screen/User/Profile/HistoryPage.dart';
import 'package:my_book/Screen/LogInPage.dart';

import 'package:my_book/Service/AccountController.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ตั้งค่า'),
        ),
        body: Container(
          color: const Color(0xfff5f3e8),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                ),
                child: const Card(
                    child: ListTile(
                        title: Text("เปลี่ยนรหัสผ่าน"),
                        leading: Icon(
                          Icons.password,
                          size: 40,
                          color: Color(0xffcaa171),
                        ),
                        trailing: Icon(Icons.navigate_next))),
              ),
              GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditAddressPage()),
                    );
                  },
                  child: const Card(
                      child: ListTile(
                          title: Text("แก้ไขข้อมูลการจัดส่ง"),
                          leading: Icon(Icons.edit_location_outlined,
                              size: 40, color: Color(0xffcaa171)),
                          trailing: Icon(Icons.navigate_next)))),
              GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()),
                      ),
                  child: const Card(
                      child: ListTile(
                          title: Text("แก้ไขโปร์ไฟล์"),
                          leading: Icon(Icons.account_circle_outlined,
                              size: 40, color: Color(0xffcaa171)),
                          trailing: Icon(Icons.navigate_next)))),
              GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryPage()),
                      ),
                  child: const Card(
                      child: ListTile(
                          title: Text("ประวัติการซื้อขาย"),
                          leading: Icon(Icons.history,
                              size: 40, color: Color(0xffcaa171)),
                          trailing: Icon(Icons.navigate_next)))),
              GestureDetector(
                  onTap: () {
                    AccountController().logout().then((value) =>
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogInPage())));
                  },
                  child: const Card(
                      child: ListTile(
                    title: Text("ออกจากระบบ"),
                    leading:
                        Icon(Icons.logout, size: 40, color: Color(0xffcaa171)),
                  ))),
            ],
          ),
        ));
  }
}

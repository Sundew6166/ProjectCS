import 'package:flutter/material.dart';
import 'package:my_book/Screen/User/Profile/ChangePasswordPage.dart';
import 'package:my_book/Screen/User/Profile/EditProfilePage.dart';

import 'package:my_book/Screen/LogInPage.dart';
import 'package:my_book/Service/AccountController.dart';

class SettingAdmin extends StatelessWidget {
  const SettingAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ตั้งค่า',
          ),
        ),
        body: Container(
          color: Color(0xfff5f3e8),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              // Password
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                ),
                child: Card(
                    child: ListTile(
                        title: Text("เปลี่ยนรหัสผ่าน"),
                        // subtitle: Text("The battery is full."),
                        leading: Icon(
                          Icons.password,
                          size: 40,
                          color: Color(0xffcaa171),
                        ),
                        trailing: Icon(Icons.navigate_next))),
              ),
              // Profile
              GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()),
                      ),
                  child: Card(
                      child: ListTile(
                          title: Text("แก้ไขโปร์ไฟล์"),
                          leading: Icon(Icons.account_circle_outlined,
                              size: 40, color: Color(0xffcaa171)),
                          trailing: Icon(Icons.navigate_next)))),

              // Log out
              GestureDetector(
                  onTap: () {
                    AccountController().logout().then((value) =>
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInPage())));
                  },
                  child: Card(
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
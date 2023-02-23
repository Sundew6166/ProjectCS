import 'package:flutter/material.dart';
import 'package:my_book/User/Profile/ChangePasswordPage.dart';
import 'package:my_book/User/Profile/EditAddressPage.dart';
import 'package:my_book/User/Profile/EditProfilePage.dart';
import 'package:my_book/User/Profile/HistoryPage.dart';

import 'package:my_book/User/RegisterPage.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Widget _arrow() {
    return Icon(
      Icons.arrow_forward_ios,
      size: 20.0,
    );
  }

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
              // Address
              GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditAddressPage()),
                      ),
                  child: Card(
                      child: ListTile(
                          title: Text("แก้ไขข้อมูลการจัดส่ง"),
                          leading: Icon(Icons.edit_location_outlined,
                              size: 40, color: Color(0xffcaa171)),
                          trailing: Icon(Icons.navigate_next)))),
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
              // History
              GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryPage()),
                      ),
                  child: Card(
                      child: ListTile(
                          title: Text("ประวัติการซื้อขาย"),
                          leading: Icon(Icons.history,
                              size: 40, color: Color(0xffcaa171)),
                          trailing: Icon(Icons.navigate_next)))),
              // Log out
              GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      ),
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

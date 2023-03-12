import 'package:flutter/material.dart';

import 'package:my_book/Screen/User/Home/HomePage.dart';
import 'package:my_book/Screen/User/Scan/BarCodeScan.dart';
import 'package:my_book/Screen/User/Profile/ProfilePage.dart';
import 'package:my_book/Screen/Admin/HomeAdmin.dart';
import 'package:my_book/Screen/Admin/ProfileAdmin.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key? key, required this.accType, required this.tab})
      : super(key: key);

  String accType;
  String tab;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;

  static final List<Widget> _userOptions = <Widget>[
    const HomePage(),
    BarCodeScan(type: "USER"),
    const Profile(),
  ];

  static final List<Widget> _adminOptions = <Widget>[
    const HomeAdmin(),
    BarCodeScan(type: "ADMIN"),
    const ProfileAdmin(),
  ];

  @override
  void initState() {
    String tab = widget.tab;
    currentIndex = tab == "PROFILE"
        ? 2
        : tab == "BARCODESCAN"
            ? 1
            : 0;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.accType == 'USER'
            ? _userOptions.elementAt(currentIndex)
            : _adminOptions.elementAt(currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'สแกน'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
        selectedItemColor: Colors.white,
        backgroundColor: const Color(0xff795e35),
        unselectedItemColor: Colors.white38,
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

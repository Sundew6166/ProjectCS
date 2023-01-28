import 'package:flutter/material.dart';

class SaleTab extends StatefulWidget {
  const SaleTab({super.key});

  @override
  State<SaleTab> createState() => _SaleTabState();
}

class _SaleTabState extends State<SaleTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: Center(
      // child: ElevatedButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
        child: const Text('ขายโว้ยย'),
        // ),
      ),
    // )
    );
  }
}

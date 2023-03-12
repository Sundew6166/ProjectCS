import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TextEditingController textarea = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการซื้อขาย'),
      ),
      body: ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                "หมายเลขคำสั่งซื้อ $index",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Text("\tชื่อหนังสือ",
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text("วันเดือนปีที่ทำรายการ",
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                    Text("ยอดรวม .... บาท",
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ]),
            );
          }),
    );
  }
}

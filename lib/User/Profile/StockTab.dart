import 'package:flutter/material.dart';

class StockTab extends StatefulWidget {
  const StockTab({super.key});

  @override
  State<StockTab> createState() => _StockTabState();
}

class _StockTabState extends State<StockTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView.builder(
        padding: const EdgeInsets.all(5),
        itemBuilder: (context, i) {
          return Container(
            height: 100,
            child: Card(
              elevation: 10,
              child: Row(
                children: <Widget>[
                  Padding(
                    // padding: EdgeInsets.all(7.0),
                    padding: EdgeInsets.fromLTRB(7, 7, 20, 0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 70.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            color: Color(0xffc3c3d6),
                            image: DecorationImage(
                                image: AssetImage("images/Conan.jpg"),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ]),
                      ),
                    ),
                  ),
                  GestureDetector(
                    
                    onTap: () {
                    },
                    child: Center(
                      child: Text(
                        "ชื่อหนังสือ" + '\n' + 'ISBN' + '\n' + 'ชื่อคนแต่ง' + '\n' + '.....',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

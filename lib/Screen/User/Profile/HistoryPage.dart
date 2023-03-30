import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_book/Service/SaleController.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic>? historyList;
  @override
  void initState() {
    setData();
    super.initState();
  }

  Future<void> setData() async {
    await SaleController().getMyHistory().then((value) {
      setState(() {
        historyList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return historyList != null
        ? Scaffold(
            appBar: AppBar(
              title: const Text('ประวัติการซื้อขาย'),
            ),
            body: RefreshIndicator(
              onRefresh: setData,
              child: historyList!.isEmpty
                  ? const CustomScrollView(slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(110, 20, 0, 0),
                          child: Text("ไม่มีประวัติการซื้อขาย",
                              style: TextStyle(fontSize: 18)),
                        ),
                      )
                    ])
                  : ListView.builder(
                      itemCount: historyList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            historyList![index]['id'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('\t${historyList![index]['book']['title']}',
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                    DateFormat('dd/MM/yyyy-kk:mm').format(
                                        historyList![0]['updateDateTime']
                                            .toDate()),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                                Text(
                                    '${historyList![index]['deliveryFee'] + historyList![index]['sellingPrice']}฿',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                              ]),
                        );
                      }),
            ))
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xfff5f3e8),
            child: Center(
              child: Lottie.network(
                  'https://assets1.lottiefiles.com/packages/lf20_yyytgjwe.json'),
            ),
          );
  }
}

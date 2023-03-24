import 'package:flutter/material.dart';

import 'package:my_book/Screen/User/Hub/BuyPage.dart';
import 'package:my_book/Service/SaleController.dart';

class SaleTab extends StatefulWidget {
  SaleTab({super.key, required this.sales, required this.page});
  List<dynamic> sales;
  String page;

  @override
  State<SaleTab> createState() => _SaleTabState();
}

class _SaleTabState extends State<SaleTab> {
  @override
  void initState() {
    reFresh();
    super.initState();
  }

  Future<void> reFresh() async {
    if (widget.page == 'home') {
      await SaleController().getAllSale().then((value) {
        setState(() {
          widget.sales = value;
        });
      });
    } else {
      widget.sales = widget.sales;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: reFresh,
      child: widget.sales.isEmpty
          ? const Center(
              child: Text("ไม่มีการขาย", style: TextStyle(fontSize: 18)))
          : Container(
              color: const Color(0xfff5f3e8),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemCount: widget.sales.length,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BuyPage(saleInfo: widget.sales[index])),
                            ),
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        widget.sales[index]['image'],
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              widget.sales[index]['book']
                                                  ['title'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${widget.sales[index]['sellingPrice']}฿',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.red),
                                          ),
                                        ]))
                              ],
                            ),
                          ),
                        ));
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisExtent: 290,
                  ),
                ),
              )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_book/Screen/User/Hub/PaymentPage.dart';
import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/NotificationController.dart';
import 'package:my_book/Service/SaleController.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key, required this.notiList});

  List<dynamic> notiList;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic>? notiList;
  bool isRefresh = false;

  @override
  void initState() {
    setData();
    super.initState();
  }

  Future<void> setData() async {
    if (isRefresh) {
      widget.notiList = (await NotificationController().getListNoti())["notiList"];
    } else {
      setState(() => isRefresh = true);
    }
    if (widget.notiList == []) {
      setState(() => notiList = []);
    } else {
      await NotificationController().getNotificationInformation(widget.notiList)
        .then((value) => setState(() => notiList = value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return (notiList != null)
      ? Scaffold(
          appBar: AppBar(
            title: const Text("แจ้งเตือน"),
          ),
          body: RefreshIndicator(
            onRefresh: setData,
            child: (notiList!.isEmpty)
              ? const CustomScrollView(
                  slivers: <Widget>[
                    SliverFillRemaining(
                      child: Center(
                        child: Text("ไม่มีแจ้งเตือน", style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                )
              : Container(
                  color: const Color(0xfff5f3e8),
                  child: ListView.builder(
                    itemCount: notiList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var data = notiList![index];
                          await NotificationController().updateIsRead(data["id"]);
                          if (data!["type"] == "A") {
                            var bookInfo = data["moreInfo"];
                            var hasBook = await BookController().checkHasBook(bookInfo!["isbn"], bookInfo["edition"].toString());
                            var hasSale = hasBook ? await SaleController().checkHasSale(bookInfo!["isbn"], bookInfo["edition"].toString()) : false;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage(bookInfo: bookInfo, hasBook: hasBook, hasSale: hasSale)));
                          } else if (data["type"] == "P" && DateTime.now().isBefore(notiList![index]!["dateTime"].add(const Duration(minutes: 5)))) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(saleInfo: data["moreInfo"])));
                          } else if (data["type"] == "S") {
                            await Clipboard.setData(ClipboardData(text: notiList![index]!["moreInfo"]["deliveryInfo"]))
                              .then((value) => Fluttertoast.showToast(
                                msg: "คัดลอกที่อยู่จัดส่งเรียบร้อยแล้ว",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.black,
                                fontSize: 18.0
                              ));
                          }
                        },
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            color: notiList![index]!["isRead"] ? Colors.white : const Color(0xffe9edf8),
                            child: ListTile(
                              leading: Icon(
                                Icons.notifications_active,
                                size: 40,
                                color: notiList![index]!["isRead"] ? Colors.grey : Colors.red,
                              ),
                              title: Text(
                                notiList![index]!["moreInfo"]["title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                (notiList![index]!["type"] == "A")
                                ? "หนังสือได้รับการอนุมัติแล้ว"
                                : (notiList![index]!["type"] == "P")
                                  ? "กรุณาแจ้งชำระเงินภายใน 5 นาที"
                                  : "กรุณาจัดส่งหนังสือ อย่าลืมเอาหนังสือออกจากคลัง",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                  DateFormat("dd/MM/yyyy \n kk:mm").format(notiList![index]!["dateTime"]),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
                            ),
                          )
                        )
                      );
                    }
                  )
                )
          )
        )
      : Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xfff5f3e8),
          child: Center(
            child: Lottie.network("https://assets1.lottiefiles.com/packages/lf20_yyytgjwe.json"),
          ),
        );
  }
}

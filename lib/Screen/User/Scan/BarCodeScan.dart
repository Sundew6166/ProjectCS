import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:my_book/Screen/BottomBar.dart';
import 'package:my_book/Screen/User/Hub/AddBook.dart';
import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Screen/User/Scan/AddSale.dart';
import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/SaleController.dart';

class BarCodeScan extends StatefulWidget {
  BarCodeScan({super.key, required this.type});

  String type;

  @override
  State<BarCodeScan> createState() => _BarCodeScanState();
}

class _BarCodeScanState extends State<BarCodeScan> {
  String? result;
  List<String> editions = [];
  bool hasBook = false;
  bool hasSale = false;
  Map<String, dynamic>? bookInfo;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");

  String? dropdownValue;

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(accType: widget.type, tab: "HOME")));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("แสกนบาร์โค้ด"),
        ),
        body: Container(
          color: const Color(0xfff5f3e8),
          child: Column(
            children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context)),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Text("กรุณาสแกนบาร์โค้ด"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return const Text("แฟลช");
                                },
                              )
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller?.flipCamera();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return const Text("สลับกล้อง");
                                  } else {
                                    return const Text("กำลังโหลด");
                                  }
                                },
                              )
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      )
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 350.0 : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData.code;
        controller.pauseCamera();
        editions = await BookController().getEditionsBook(result!);
        if (editions.isNotEmpty) {
          dropdownValue = editions.first;
          editions.add("เพิ่ม");
          bookInfo = await BookController().getBookInfo(result!, dropdownValue!);
          hasBook = await BookController().checkHasBook(result!, dropdownValue!);
          hasSale = hasBook ? await SaleController().checkHasSale(result!, dropdownValue!) : false;
        } else {
          bookInfo = null;
          hasBook = false;
          hasSale = false;
        }

        if (widget.type == "ADMIN" && bookInfo == null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddBook(accType: widget.type, isbn: result)))
            .then((value) => controller.resumeCamera());
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: (bookInfo != null)
                ? bookInfo!["approveStatus"]
                  ? SizedBox(
                      height: 160,
                      width: 320,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(bookInfo!["coverImage"], height: 120, width: 80)
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(bookInfo!["title"], overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 18)),
                                  Text("\n${bookInfo!["isbn"]}", overflow: TextOverflow.ellipsis),
                                  InkWell(
                                    splashColor: const Color(0xff795e35).withOpacity(0.5),
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage(bookInfo: bookInfo!, hasBook: hasBook, hasSale: hasSale))),
                                    child: const Text("รายละเอียดอื่น", style: TextStyle(color: Color(0xff795e35), fontWeight: FontWeight.bold)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Text("ครั้งที่พิมพ์: "),
                                      DropdownButton<String>(
                                        value: dropdownValue,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(color: Color(0xff795e35)),
                                        underline: Container(height: 2, color: const Color(0xff795e35)),
                                        onChanged: (String? value) async {
                                          if (value == "เพิ่ม") {
                                            bookInfo!["edition"] = "";
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddBook(accType: widget.type, bookInfo: bookInfo)))
                                              .then((value) {
                                                controller.resumeCamera();
                                                Navigator.of(context).pop();
                                              });
                                          } else {
                                            dropdownValue = value!;
                                            bookInfo = await BookController().getBookInfo(result!, dropdownValue!);
                                            hasBook = await BookController().checkHasBook(result!, dropdownValue!);
                                            hasSale = hasBook ? await SaleController().checkHasSale(result!, dropdownValue!) : false;
                                          }
                                        },
                                        items: editions.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                                      )
                                    ]
                                  )
                                ]
                              )
                            )
                          ),
                        ]
                      )
                    )
                  : const Text("หนังสือเล่มนี้กำลังรอการอนุมัติ\nกรุณาลองใหม่ในภายหลัง")
                : const Text("ยังไม่มีข้อมูลของหนังสือเล่มนี้\nช่วยเพิ่มคลังหนังสือของพวกเรา"),
              actions: <Widget>[
                if (widget.type == "ADMIN")
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddBook(accType: widget.type, bookInfo: bookInfo)))
                        .then((value) {
                          controller.resumeCamera();
                          Navigator.of(context).pop();
                        });
                    },
                    child: Text(bookInfo!["approveStatus"] ? "แก้ไขข้อมูล" : "ไปอนุมัติข้อมูล"),
                  )
                else if (editions.isEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddBook(accType: widget.type, isbn: result)))
                        .then((value) {
                          controller.resumeCamera();
                          Navigator.of(context).pop();
                        });
                    },
                    child: const Text("เพิ่มข้อมูล"),
                  )
                else if (!bookInfo!["approveStatus"])
                  TextButton(
                    onPressed: () {
                      controller.resumeCamera();
                      Navigator.of(context).pop();
                    },
                    child: const Text("ตกลง"),
                  )
                else if (hasSale)
                  const TextButton(
                    onPressed: null,
                    child: Text("กำลังขาย"),
                  )
                else if (hasBook)
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddSale(bookInfo: bookInfo!)))
                        .then((value) {
                          controller.resumeCamera();
                          Navigator.of(context).pop();
                        });
                    },
                    child: const Text("ขาย"),
                  )
                else
                  TextButton(
                    onPressed: () async {
                      await BookController().addBookToLibrary(bookInfo!["isbn"], bookInfo!["edition"].toString())
                              .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => BottomBar(accType: widget.type, tab: "PROFILE"))));
                    },
                    child: const Text("เพิ่มไปคลังหนังสือ"),
                  ),
                TextButton(
                  onPressed: () {
                    controller.resumeCamera();
                    Navigator.of(context).pop();
                  },
                  child: const Text("ยกเลิก"),
                ),
              ],
            )
          );
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log("${DateTime.now().toIso8601String()}_onPermissionSet $p");
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ไม่ได้รับอนุญาต")));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

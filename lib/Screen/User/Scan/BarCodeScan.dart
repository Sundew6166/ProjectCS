import 'package:flutter/material.dart';
import 'package:my_book/Service/AccountController.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:my_book/Screen/User/Hub/ReviewPage.dart';
import 'package:my_book/Screen/User/Hub/AddBook.dart';
import 'package:my_book/Screen/User/Scan/AddSale.dart';
import 'package:my_book/Screen/BottomBar.dart';

class BarCodeScan extends StatefulWidget {
  const BarCodeScan({super.key});

  @override
  State<BarCodeScan> createState() => _BarCodeScanState();
}

class _BarCodeScanState extends State<BarCodeScan> {
  String? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // }
    // controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("แสกนบาร์โค้ด"),
            ),
            body: Container(
              color: Color(0xfff5f3e8),
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
                          // TODO: ไม่มีหนังสือในคลัง => ReviewPage
                          // if (result != null)
                          //   ElevatedButton(
                          //       onPressed: (() {
                          // Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => ReviewPage()),
                          //       );
                          // }),
                          //       child: Text('เพิ่มไปคลังหนังสือ')),

                          // // TODO: มีหนังสือในคลัง => AddSale หรือ form ขาย
                          // if (result != null)
                          //     ElevatedButton(
                          //         onPressed: (() {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => AddSale()),
                          // );
                          // }),
                          //         child: Text('เพิ่มไปยังการขาย')),
                          // TODO: ไม่มีข้อมูลใน database NewBook หรือ form นส ใหม่
                          if (result != null)
                            ElevatedButton(
                                onPressed: (() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddBook(isbn: result.toString())),
                                  );
                                }),
                                child: Text('เพิ่มหนังสือใหม่'))
                          else
                            const Text('กรุณาสแกนบาร์โค้ด'),
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
                                        // return Text('Flash: ${snapshot.data}');
                                        return Text('แฟลช');
                                      },
                                    )),
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
                                          // return Text(
                                          //     'Camera facing ${describeEnum(snapshot.data!)}');
                                          return Text('สลับกล้อง');
                                        } else {
                                          return const Text('กำลังโหลด');
                                        }
                                      },
                                    )),
                              )
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: <Widget>[
                          //     Container(
                          //       margin: const EdgeInsets.all(8),
                          //       child: ElevatedButton(
                          //         onPressed: () async {
                          //           await controller?.pauseCamera();
                          //         },
                          //         child: const Text('pause',
                          //             style: TextStyle(fontSize: 20)),
                          //       ),
                          //     ),
                          //     Container(
                          //       margin: const EdgeInsets.all(8),
                          //       child: ElevatedButton(
                          //         onPressed: () async {
                          //           await controller?.resumeCamera();
                          //         },
                          //         child: const Text('resume',
                          //             style: TextStyle(fontSize: 20)),
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 350.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่ได้รับอนุญาต')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

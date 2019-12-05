import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adyen/flutter_adyen.dart';
import 'package:flutter_adyen_example/mock_data.dart' as prefix0;

import 'mock_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _debugInfo = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  String dropInResponse;

  Future<void> initPlatformState() async {
    if (!mounted) return;

    setState(() {
      _debugInfo = dropInResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            var scheme = returnScheme + '://';
            var ref = "5933644c-ab32-49f7-a9cd-fd2dc87fab2e";

            try {
              dropInResponse = await FlutterAdyen.choosePaymentMethod(
                paymentMethods: jsonEncode(examplePaymentMethods),
                urlPayments: urlPayments,
                urlPaymentsDetails: urlPaymentsDetails,
                authToken: authToken,
                merchantAccount: merchantAccount,
                publicKey: pubKey,
                amount: 12.0,
                currency: 'EUR',
                iosReturnUrl: scheme,
                reference: ref,
                shopperReference: userID,
                allow3DS2: true
              );
            } on PlatformException {
              dropInResponse = 'PlatformException.';
            } on Exception {
              dropInResponse = 'Exception.';
            }

            setState(() {
              _debugInfo = dropInResponse;
            });

            var res = await FlutterAdyen.sendResponse({
              "resultCode": "RedirectShopper",
              "action": {
                "data": {
                  "MD": "OEVudmZVMUlkWjd0MDNwUWs2bmhSdz09...",
                  "PaReq": "eNpVUttygjAQ/RXbDyAXBYRZ00HpTH3wUosPfe...",
                  "TermUrl": "adyencheckout://your.package.name"
                },
                "method": "POST",
                "paymentData": "Ab02b4c0!BQABAgA4e3wGkhVah4CJL19qdegdmm9E...",
                "paymentMethodType": "scheme",
                "type": "redirect",
                "url": "https://test.adyen.com/hpp/3d/validate.shtml"
              },
              "details": [
                {
                  "key": "MD",
                  "type": "text"
                },
                {
                  "key": "PaRes",
                  "type": "text"
                }
              ],
            });

            setState(() {
              _debugInfo = dropInResponse + "||||" + res;
            });
          },
        ),
        appBar: AppBar(
          title: const Text('Flutter Adyen'),
        ),
        body: Center(
          child: Text('Running on: $_debugInfo\n'),
        ),
      ),
    );
  }
}

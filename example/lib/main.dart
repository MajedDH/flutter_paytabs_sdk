import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Map<String, String> platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
//      platformVersion = ;
    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
//      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: RaisedButton(
            child: Text("TT"),
            onPressed: () async {
              //   var x = await Paytabsflutter.openActivity(
              //     customer_name: "Majed Daas",
              //     merchant_email: "freedoumanian@gmail.com",
              //     secret_key:
              //         "secret key",
              //     transaction_title:
              //         "some transaction for some client",
              //     amount: 50.0,
              //     currency_code: "SAR",
              //     customer_phone_number: "+999999999999",
              //     customer_email: "example@gmail.com",
              //     order_id: "111111",
              //     product_name: "names",
              //     billing_address: "Some neighborhood., 99999 st. No 35/1",
              //     billing_city: "city",
              //     billing_state: "state",
              //     billing_country: "SAU",
              //     billing_postal_code: "00000",
              //     language: "ar",
              //   );
//              print(x);
            },
          ),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}

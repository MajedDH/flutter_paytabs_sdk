import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytabsflutter/paytabsflutter.dart';

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
              var x = await Paytabsflutter.openActivity(
                merchant_email: "freedoumanian@gmail.com",
                secret_key:
                    "0NOkmHRn2sqRAiH4VWPlIEdF8I146cq6ZerlViIYK9PkrwpnseIaTVP1DR6K3wQ2LhoGz7FjguEH134tiNEbJudnlj7oQXrBeQiO",
                transaction_title:
                    "Consultation أحوال شخصية from lawyer مكتب الفارس القانوني to agent: Majed Daas",
                amount: 50.0,
                currency_code: "SAR",
                customer_phone_number: "+905531777384",
                customer_email: "abdalrazak.it@gmail.com",
                order_id: "283",
                product_name: "bsjsks",
                billing_address: "Guneykent Mh., 10222 Sk. No 35/1",
                billing_city: "Gaziantep",
                billing_state: "Gaziantep",
                billing_country: "SAU",
                billing_postal_code: "27200",
                language: "ar",
              );
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

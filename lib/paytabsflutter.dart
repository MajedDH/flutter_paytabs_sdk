import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Paytabsflutter {
  static const MethodChannel _channel = const MethodChannel('paytabsflutter');

  static Future<Map<String, String>> openActivity({
    @required String merchant_email,
    @required String secret_key,
    @required String transaction_title,
    @required double amount,
    @required String currency_code,
    @required String customer_phone_number,
    @required String customer_email,
    @required String customer_name,
    @required String order_id,
    @required String product_name,
    @required String billing_address,
    @required String billing_city,
    @required String billing_state,
    @required String billing_country,
    @required String billing_postal_code,
    String language,
  }) async {
    Map<dynamic, dynamic> map = await _channel.invokeMethod('openActivity', {
      "merchant_email": merchant_email,
      "secret_key": secret_key,
      "transaction_title": transaction_title,
      "amount": amount,
      "currency_code": currency_code,
      "customer_phone_number": customer_phone_number,
      "customer_name": customer_name,
      "customer_email": customer_email,
      "order_id": order_id,
      "product_name": product_name,
      "billing_address": billing_address,
      "billing_city": billing_city,
      "billing_state": billing_state,
      "billing_country": billing_country,
      "billing_postal_code": billing_postal_code,
      "language": language
    });
    return map.cast<String, String>();
  }
}

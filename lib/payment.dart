import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class StripePayment {
  /// logger
  static final _logger = Logger();

  /// create payment intent
  static Future createPaymentIntent({
    required String name,
    required String address,
    required String pin,
    required String city,
    required String state,
    required String country,
    required String currency,
    required String amount,
  }) async {
    ///
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');

    ///
    final secretKey = dotenv.env["STRIPE_SECRET_KEY"]!;

    ///
    final body = {
      'amount': amount,
      'currency': currency.toLowerCase(),
      'automatic_payment_methods[enabled]': 'true',
      'description': "Test Donation",
      'shipping[name]': name,
      'shipping[address][line1]': address,
      'shipping[address][postal_code]': pin,
      'shipping[address][city]': city,
      'shipping[address][state]': state,
      'shipping[address][country]': country
    };

    ///
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );

    _logger.i("body: $body");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      _logger.i("json: $json");
      return json;
    } else {
      _logger.i("error in calling payment intent");
    }
  }
}

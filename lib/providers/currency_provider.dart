import 'dart:convert';

import 'package:expensee/models/currency_rates.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Currencies with ChangeNotifier {
  String primaryCurrency = 'SGD';
  late CurrencyRates currencyRates;

  void setPrimary(String code) {
    primaryCurrency = code;
    notifyListeners();
  }

  Future<CurrencyRates> getCurrencyRate(String base) async {
    String URL;

    if (base == 'USD') {
      URL =
          'https://api.exchangerate.host/latest?base=USD&symbols=EUR,SGD,THB&places=2';
    } else if (base == 'EUR') {
      URL =
          'https://api.exchangerate.host/latest?base=EUR&symbols=SGD,THB,USD&places=2';
    } else if (base == 'THB') {
      URL =
          'https://api.exchangerate.host/latest?base=THB&symbols=EUR,SGD,USD&places=2';
    } else {
      URL =
          'https://api.exchangerate.host/latest?base=SGD&symbols=EUR,THB,USD&places=2';
    }

    Response response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      CurrencyRates decoded = CurrencyRates.fromJson(jsonDecode(response.body));
      return decoded;
    }
    throw Exception('Failed to load currency rates');
  }
}

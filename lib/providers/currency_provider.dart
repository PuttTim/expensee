import 'dart:convert';

import 'package:expensee/models/currency_rates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Currencies with ChangeNotifier {
  String primaryCurrency = 'SGD';
  late CurrencyRates currencyRates;

  void setPrimary(String code) {
    primaryCurrency = code;
    notifyListeners();
  }

  Future<CurrencyRates> getCurrencyRate() async {
    final String response = await rootBundle.loadString('assets/rates.json');
    dynamic decoded = CurrencyRates.fromJson(jsonDecode(response));

    return decoded;
  }
}

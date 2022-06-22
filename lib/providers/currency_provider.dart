import 'package:flutter/material.dart';

class Currencies with ChangeNotifier {
  String currencyRates = '{
    "EUR": {
      "SGD": 1.46,
      "THB": 37.23,
      "USD": 1.05,
    },
    "SGD": {
      "EUR": 0.72,
      "THB": 25.5,
      "USD": 0.72,
    },
    "THB": {
      "EUR": 0.03,
      "SGD": 0.04,
      "USD": 0.03,
    },
    "USD": {
      "EUR": 0.95,
      "SGD": 1.39,
      "THB": 35.46,
    }
  }';
  String primaryCurrency = 'SGD';

  void setPrimary(String code) {
    primaryCurrency = code;
    notifyListeners();
  }

  String getCurrencyRates(String base) {
    return currencyRates[base].toString();
  }
}

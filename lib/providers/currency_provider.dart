import 'package:flutter/material.dart';

class Currencies with ChangeNotifier {
  String primaryCurrency = 'SGD';

  void setPrimary(String code) {
    primaryCurrency = code;
    notifyListeners();
  }
}

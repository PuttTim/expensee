import 'dart:convert';

import 'package:expensee/models/currency_rates.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CurrenciesProvider with ChangeNotifier {
  String primaryCurrency = 'SGD';
  late CurrencyRates currencyRates;

  // Sets the primaryCurrency String to the passed in currency code (i.e EUR, SGD, THB or USD).
  void setPrimary(String code) {
    primaryCurrency = code;

    /// Notifies any listeners (typically in the codebase will be Consumer<CurrenciesProvider>.
    notifyListeners();
  }

  Future<CurrencyRates> getCurrencyRate(String base) async {
    String apiURL;

    /// Switch/case would not work for some reason, so I'm using if/else for now.
    if (base == 'USD') {
      apiURL = 'https://api.exchangerate.host/latest?base=USD&symbols=EUR,SGD,THB&places=2';
    } else if (base == 'EUR') {
      apiURL = 'https://api.exchangerate.host/latest?base=EUR&symbols=SGD,THB,USD&places=2';
    } else if (base == 'THB') {
      apiURL = 'https://api.exchangerate.host/latest?base=THB&symbols=EUR,SGD,USD&places=2';
    } else {
      apiURL = 'https://api.exchangerate.host/latest?base=SGD&symbols=EUR,THB,USD&places=2';
    }

    /// Fetches the JSON data from the API endpoint
    Response response = await http.get(Uri.parse(apiURL));

    /// If the response is successful, parse the JSON data and return the decoded CurrencyRates response to the function caller.
    if (response.statusCode == 200) {
      CurrencyRates decoded = CurrencyRates.fromJson(jsonDecode(response.body));
      return decoded;
    }
    throw Exception('Failed to load currency rates');
  }
}

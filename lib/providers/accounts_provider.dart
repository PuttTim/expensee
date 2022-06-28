import 'package:flutter/material.dart';

import '../models/account.dart';

class AccountsProvider with ChangeNotifier {
  List<Account> accounts = [
    Account(
      name: 'All',
      primaryCurrency: 'SGD',
      value: 0.0,
      budgetLimit: 0.0,
    ),
    Account(
      name: 'Credit Card',
      primaryCurrency: 'SGD',
      value: 0.0,
      budgetLimit: 0.0,
    ),
    Account(
      name: 'Bank Account',
      primaryCurrency: 'SGD',
      value: 0,
      budgetLimit: 0.0,
    ),
  ];

  late Account currentAccount;

  void setCurrentAccount(Account account) {
    debugPrint('setCurrentAccount: ${account.name}');
    currentAccount = account;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}

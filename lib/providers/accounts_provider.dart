import 'package:flutter/material.dart';

import '../models/account.dart';

class AccountsProvider with ChangeNotifier {
  List<Account> accounts = [
    Account(
      id: '1',
      name: 'All',
      primaryCurrency: 'SGD',
      value: 2500.0,
      budgetLimit: 0.0,
    ),
  ];

  late Account currentAccount = accounts[0];

  void setCurrentAccount(Account account) {
    // debugPrint('setCurrentAccount: ${account.name}');
    currentAccount = account;
    notifyListeners();
  }

  void addAccount(Account account) {
    accounts.add(account);

    debugPrint(account.id);
    notifyListeners();
  }

  modifyAccountValue({
    required String id,
    required bool isPositive,
    required double amount,
  }) async {
    final account = accounts.firstWhere((account) => account.id == id);

    debugPrint('ACCOUNT ID ${account.id}');

    account.value += isPositive ? amount : -amount;

    // if (isPositive) {
    //   account.value += amount;
    // } else {
    //   account.value -= amount;
    // }
    notifyListeners();
  }

  void setPrimaryCurrency(String currency) {
    currentAccount.primaryCurrency = currency;
    notifyListeners();
  }

  Account fetchAccount(String id) {
    return accounts.firstWhere((account) => account.id == id);
  }

  void refresh() {
    notifyListeners();
  }
}

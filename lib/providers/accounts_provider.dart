import 'package:flutter/material.dart';

import '../models/account.dart';

class AccountsProvider with ChangeNotifier {
  /// List of default accounts provided inside the Application for testing purposes.
  List<Account> accounts = [
    Account(
      id: '1',
      name: 'Wallet',
      primaryCurrency: 'SGD',
      value: 2500.0,
      budgetLimit: 0.0,
      isCurrentAccount: true,
    ),
    Account(
      id: '2',
      name: 'OCBC Frank',
      primaryCurrency: 'SGD',
      value: 250.0,
      budgetLimit: 0.0,
      isCurrentAccount: false,
    ),
    Account(
      id: '3',
      name: 'SCB Savings',
      primaryCurrency: 'THB',
      value: 2500.0,
      budgetLimit: 0.0,
      isCurrentAccount: false,
    ),
  ];

  /// Default set the currentAccount to the Wallet account.
  late Account currentAccount = accounts[0];

  /// Sets the currentAccount by passing in an [Account] object.
  void setCurrentAccount(Account account) {
    currentAccount = account;
    notifyListeners();
  }

  /// Adds an account to the list by passing in an [Account] object.
  void addAccount(Account account) {
    accounts.add(account);

    notifyListeners();
  }

  /// Modifies the value of an account by passing in id, isPositive and amount].
  modifyAccountValue({
    required String id,
    required bool isPositive,
    required double amount,
  }) async {
    /// Searches the list of accounts for the account with the id passed in.
    final account = accounts.firstWhere((account) => account.id == id);

    /// Actually modifies the account's value with a ternary operator.
    account.value += isPositive ? amount : -amount;

    notifyListeners();
  }

  /// Sets the primary currency of the account.
  void setPrimaryCurrency(String currency) {
    currentAccount.primaryCurrency = currency;
    notifyListeners();
  }

  /// Fetches the account with the id passed in.
  Account fetchAccount(String id) {
    return accounts.firstWhere((account) => account.id == id);
  }
}

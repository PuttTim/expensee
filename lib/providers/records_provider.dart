import 'package:expensee/models/transaction_record.dart';
import 'package:expensee/models/transaction_type_enum.dart';
import 'package:expensee/models/transfer_record.dart';
import 'package:flutter/cupertino.dart';

import '../models/category.dart';
import '../models/transfer_type_enum.dart';

class RecordsProvider with ChangeNotifier {
  List<dynamic> records = [
    TransactionRecord(
      isPositive: false,
      accountId: '1',
      amount: -6.0,
      currency: 'SGD',
      type: TransactionType.cashless,
      payee: 'McDonalds',
      category: Category.food,
      time: DateTime.parse('2022-05-09 23:55'),
      note: 'Dinner!',
    ),
    TransactionRecord(
      isPositive: false,
      accountId: '1',
      amount: -19.89,
      currency: 'SGD',
      type: TransactionType.cash,
      payee: 'UNIQLO',
      category: Category.shopping,
      time: DateTime.parse('2022-05-09 23:55'),
      note: 'UT T-Shirt!',
    ),
    TransferRecord(
      fromAccountId: '3',
      toAccountId: '1',
      fromCurrency: 'THB',
      toCurrency: 'SGD',
      fromAmount: 250,
      toAmount: 10,
      type: TransferType.transfer,
      time: DateTime(2020, 1, 1),
      conversionRate: 25,
      note: '',
    )
  ];

  void insertRecord(dynamic record) {
    records.add(record);

    // Provider.of<AccountsProvider>(context, listen: false).modifyAccountValue(
    //   record.accountId,
    //   record.isPositive,
    //   record.amount,
    // );

    // debugPrint(record.note);
    // debugPrint(record.accountId);
    // debugPrint(record.payee);
    // debugPrint(record.category.toString());
    // debugPrint(record.time.toString());
    // debugPrint(record.amount.toString());
    // debugPrint(record.currency.toString());
    // debugPrint(record.type.toString());
    // debugPrint(record.isPositive.toString());

    notifyListeners();
  }

  void updateRecord({required int index, required dynamic record}) {
    records.removeAt(index);
    records.insert(index, record);

    notifyListeners();
  }

  void deleteRecord({required int index}) {
    records.removeAt(index);

    notifyListeners();
  }
}

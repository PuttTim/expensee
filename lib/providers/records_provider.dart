import 'package:expensee/models/transaction_record.dart';
import 'package:expensee/models/transaction_type_enum.dart';
import 'package:flutter/cupertino.dart';

import '../models/category.dart';

class RecordsProvider with ChangeNotifier {
  List<dynamic> records = [
    TransactionRecord(
      isPositive: false,
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
      amount: -19.89,
      currency: 'SGD',
      type: TransactionType.cash,
      payee: 'UNIQLO',
      category: Category.shopping,
      time: DateTime.parse('2022-05-09 23:55'),
      note: 'UT T-Shirt!',
    )
  ];

  void insertRecord(TransactionRecord record) {
    records.add(record);

    notifyListeners();
  }

  void updateRecord(
      {required int index, required TransactionRecord record, required TransactionRecord previousRecord}) {
    records.removeAt(index);
    records.insert(index, record);

    notifyListeners();
  }
}

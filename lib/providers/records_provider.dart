import 'package:expensee/models/transaction_record.dart';
import 'package:expensee/models/transaction_type_enum.dart';
import 'package:expensee/models/transfer_record.dart';
import 'package:flutter/cupertino.dart';

import '../models/category.dart';
import '../models/transfer_type_enum.dart';

class RecordsProvider with ChangeNotifier {
  /// List of default records provided inside the Application for testing purposes.
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
      time: DateTime.now(),
      conversionRate: 25,
      note: '',
    )
  ];

  /// Adds an record to the list by passing in an [TransactionRecord] or [TransferRecord] object.
  void insertRecord(dynamic record) {
    records.add(record);

    notifyListeners();
  }

  /// Modifies the value of an record by passing in the index and the new updated record].
  void updateRecord({required int index, required dynamic record}) {
    /// Removes the record object at the index,
    /// then inserts in the new updated record at the same index.
    records.removeAt(index);
    records.insert(index, record);

    notifyListeners();
  }

  /// Removes an record from the list by passing in the index.
  void deleteRecord({required int index}) {
    records.removeAt(index);

    notifyListeners();
  }
}

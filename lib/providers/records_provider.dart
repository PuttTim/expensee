import 'package:expensee/models/transaction_record.dart';
import 'package:flutter/cupertino.dart';

class RecordsProvider with ChangeNotifier {
  List<dynamic> records = [];

  void insertRecord(TransactionRecord record) {
    records.add(record);

    records.forEach((element) {
      debugPrint(record.isPositive.toString());
      debugPrint(record.amount.toString());
      debugPrint(record.currency.toString());
      debugPrint(record.type.toString());
      debugPrint(record.payee.toString());
      debugPrint(record.category.toString());
      debugPrint(record.time.toString());
      debugPrint(record.note.toString());
      debugPrint(records.toString());
    });
    notifyListeners();
  }
}

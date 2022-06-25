import 'package:expensee/models/category.dart';
import 'package:expensee/models/transaction_type_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_record.g.dart';

@JsonSerializable()
class TransactionRecord {
  bool isPositive;
  double amount;
  String currency;
  TransactionType type;
  String payee;
  Category category;
  DateTime time;
  String? note;

  TransactionRecord({
    required this.isPositive,
    required this.amount,
    required this.currency,
    required this.type,
    required this.payee,
    required this.category,
    required this.time,
    this.note,
  });

  factory TransactionRecord.fromJson(Map<String, dynamic> json) => _$TransactionRecordFromJson(json);
}

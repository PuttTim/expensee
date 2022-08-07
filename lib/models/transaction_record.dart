import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensee/models/category.dart';
import 'package:expensee/models/transaction_type_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_record.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionRecord {
  bool isPositive;
  String accountId;
  double amount;
  String currency;
  TransactionType type;
  String payee;
  Category category;
  @JsonKey(fromJson: timestampToDateTime, toJson: dateTimeToTimestamp)
  DateTime time;
  String recordType;
  String? docId;
  String? note;

  static DateTime timestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  TransactionRecord({
    required this.isPositive,
    required this.accountId,
    required this.amount,
    required this.currency,
    required this.type,
    required this.payee,
    required this.category,
    required this.time,
    required this.recordType,
    this.docId,
    this.note,
  });

  factory TransactionRecord.fromFirestore(DocumentSnapshot doc) =>
      TransactionRecord.fromJson(doc.data()! as Map<String, dynamic>);
  // JsonSerializable auto generated fromJson method.
  factory TransactionRecord.fromJson(Map<String, dynamic> json) => _$TransactionRecordFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionRecordToJson(this);
}

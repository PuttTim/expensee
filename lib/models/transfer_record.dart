import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensee/models/transfer_type_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transfer_record.g.dart';

@JsonSerializable()
class TransferRecord {
  String fromAccountId;
  String toAccountId;
  String fromCurrency;
  String toCurrency;
  double fromAmount;
  double toAmount;
  TransferType type;
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  DateTime time;
  double conversionRate;
  String recordType;
  String? note;

  static DateTime dateTimeFromTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  TransferRecord({
    required this.fromAccountId,
    required this.toAccountId,
    required this.fromCurrency,
    required this.toCurrency,
    required this.fromAmount,
    required this.toAmount,
    required this.type,
    required this.time,
    required this.conversionRate,
    required this.recordType,
    this.note,
  });

  factory TransferRecord.fromFirestore(DocumentSnapshot doc) =>
      TransferRecord.fromJson(doc.data()! as Map<String, dynamic>);
  // JsonSerializable auto generated fromJson method.
  factory TransferRecord.fromJson(Map<String, dynamic> json) => _$TransferRecordFromJson(json);
  Map<String, dynamic> toJson() => _$TransferRecordToJson(this);
}

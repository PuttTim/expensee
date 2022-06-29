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
  DateTime time;
  double conversionRate;
  String? note;

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
    this.note,
  });

  // JsonSerializable auto generated fromJson method.
  factory TransferRecord.fromJson(Map<String, dynamic> json) => _$TransferRecordFromJson(json);
}

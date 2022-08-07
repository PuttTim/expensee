// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRecord _$TransactionRecordFromJson(Map<String, dynamic> json) =>
    TransactionRecord(
      isPositive: json['isPositive'] as bool,
      accountId: json['accountId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      payee: json['payee'] as String,
      category: $enumDecode(_$CategoryEnumMap, json['category']),
      time: TransactionRecord.timestampToDateTime(json['time'] as Timestamp),
      recordType: json['recordType'] as String,
      docId: json['docId'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$TransactionRecordToJson(TransactionRecord instance) =>
    <String, dynamic>{
      'isPositive': instance.isPositive,
      'accountId': instance.accountId,
      'amount': instance.amount,
      'currency': instance.currency,
      'type': _$TransactionTypeEnumMap[instance.type],
      'payee': instance.payee,
      'category': _$CategoryEnumMap[instance.category],
      'time': TransactionRecord.dateTimeToTimestamp(instance.time),
      'recordType': instance.recordType,
      'docId': instance.docId,
      'note': instance.note,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.cash: 'cash',
  TransactionType.cashless: 'cashless',
  TransactionType.online: 'online',
};

const _$CategoryEnumMap = {
  Category.food: 'food',
  Category.shopping: 'shopping',
  Category.transport: 'transport',
  Category.housing: 'housing',
  Category.others: 'others',
};

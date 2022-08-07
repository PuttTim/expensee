// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferRecord _$TransferRecordFromJson(Map<String, dynamic> json) =>
    TransferRecord(
      fromAccountId: json['fromAccountId'] as String,
      toAccountId: json['toAccountId'] as String,
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
      fromAmount: (json['fromAmount'] as num).toDouble(),
      toAmount: (json['toAmount'] as num).toDouble(),
      type: $enumDecode(_$TransferTypeEnumMap, json['type']),
      time: TransferRecord.dateTimeFromTimestamp(json['time'] as Timestamp),
      conversionRate: (json['conversionRate'] as num).toDouble(),
      recordType: json['recordType'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$TransferRecordToJson(TransferRecord instance) =>
    <String, dynamic>{
      'fromAccountId': instance.fromAccountId,
      'toAccountId': instance.toAccountId,
      'fromCurrency': instance.fromCurrency,
      'toCurrency': instance.toCurrency,
      'fromAmount': instance.fromAmount,
      'toAmount': instance.toAmount,
      'type': _$TransferTypeEnumMap[instance.type],
      'time': TransferRecord.dateTimeToTimestamp(instance.time),
      'conversionRate': instance.conversionRate,
      'recordType': instance.recordType,
      'note': instance.note,
    };

const _$TransferTypeEnumMap = {
  TransferType.withdraw: 'withdraw',
  TransferType.transfer: 'transfer',
};

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
      time: DateTime.parse(json['time'] as String),
      conversionRate: (json['conversionRate'] as num).toDouble(),
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
      'time': instance.time.toIso8601String(),
      'conversionRate': instance.conversionRate,
      'note': instance.note,
    };

const _$TransferTypeEnumMap = {
  TransferType.withdraw: 'withdraw',
  TransferType.transfer: 'transfer',
};

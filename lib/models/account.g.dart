// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      primaryCurrency: json['primaryCurrency'] as String,
      budgetLimit: (json['budgetLimit'] as num).toDouble(),
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'primaryCurrency': instance.primaryCurrency,
      'budgetLimit': instance.budgetLimit,
    };
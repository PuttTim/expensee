// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_rates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyRates _$CurrencyRatesFromJson(Map<String, dynamic> json) =>
    CurrencyRates(
      base: json['base'] as String,
      date: json['date'] as String,
      rates: json['rates'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$CurrencyRatesToJson(CurrencyRates instance) =>
    <String, dynamic>{
      'base': instance.base,
      'date': instance.date,
      'rates': instance.rates,
    };

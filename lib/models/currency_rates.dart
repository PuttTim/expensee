import 'package:json_annotation/json_annotation.dart';

part 'currency_rates.g.dart';

@JsonSerializable()
class CurrencyRates {
  String base;
  String date;
  Map<String, dynamic> rates;

  CurrencyRates({required this.base, required this.date, required this.rates});

  factory CurrencyRates.fromJson(Map<String, dynamic> json) =>
      _$CurrencyRatesFromJson(json);
}

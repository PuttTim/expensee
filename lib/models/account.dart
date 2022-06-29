import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  String id;
  String name;
  double value;
  String primaryCurrency;
  double budgetLimit;

  Account({
    required this.id,
    required this.name,
    required this.value,
    required this.primaryCurrency,
    required this.budgetLimit,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}

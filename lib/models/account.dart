import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory Account.fromFiresstore(DocumentSnapshot doc) => Account.fromJson(doc.data()! as Map<String, dynamic>);
  // JsonSerializable auto generated fromJson method.
  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  // JsonSerializable auto generated toJson method.
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

enum TransactionType {
  @JsonValue("cash")
  cash,
  @JsonValue("cashless")
  cashless,
  @JsonValue("online")
  online,
}

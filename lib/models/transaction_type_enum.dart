import 'package:json_annotation/json_annotation.dart';

/// Enum for the Transaction type.
enum TransactionType {
  @JsonValue("cash")
  cash,
  @JsonValue("cashless")
  cashless,
  @JsonValue("online")
  online,
}

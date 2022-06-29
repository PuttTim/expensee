import 'package:json_annotation/json_annotation.dart';

/// Enum for the Transfer type.
enum TransferType {
  @JsonValue("withdraw")
  withdraw,
  @JsonValue("transfer")
  transfer,
}

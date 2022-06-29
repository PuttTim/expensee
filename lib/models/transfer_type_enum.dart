import 'package:json_annotation/json_annotation.dart';

enum TransferType {
  @JsonValue("withdraw")
  withdraw,
  @JsonValue("transfer")
  transfer,
}

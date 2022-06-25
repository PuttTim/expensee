/// Converts a country's currency code to an Unicode Emoji which can be displayed inside a Text widget.
String countryToEmoji(String currencyCode) {
  final String currencyFlag = currencyCode;

  final int firstLetter = currencyFlag.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final int secondLetter = currencyFlag.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
}

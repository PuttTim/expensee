String countryToEmoji(String currency_code) {
  final String currencyFlag = currency_code;

  final int firstLetter = currencyFlag.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final int secondLetter = currencyFlag.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
}

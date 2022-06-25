/// Capitalises the first letter of a String
/// As an extension, the function can be used on any String.
extension CapitaliseString on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

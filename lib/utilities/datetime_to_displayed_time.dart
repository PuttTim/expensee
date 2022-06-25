import 'package:intl/intl.dart';

/// Converts a DateTime object to a string in the format of 'dd/mm/yyyy hh:mm',
/// which is easier to understand for users
/// (e.g. '18/04/2022 09:00' instead of '2022-04-18T09:00:00.000Z')
///
/// This could've been an extension like in capitaliseString.dart,
/// However Flutter will not let extensions have an instanced variable, which is required by DateFormat to work.
String dateTimeToDisplayedTime(DateTime dateTime) {
  var format = DateFormat('yyyy/MM/dd @ HH:mm');
  return format.format(dateTime);
}

import 'package:intl/intl.dart';

String dateTimeToDisplayedTime(DateTime dateTime) {
  var format = DateFormat('yyyy/MM/dd @ HH:mm');
  return format.format(dateTime);
}

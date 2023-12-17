import 'package:intl/intl.dart';

class MyDateUtils {
  static String formatTaskDate(DateTime dateTime) {
    var formater = DateFormat("yyyy/MM/dd");
    return formater.format(dateTime);
  }

  static DateTime dayOnly(DateTime input) {
    return DateTime(input.year, input.day, input.month);
  }
}

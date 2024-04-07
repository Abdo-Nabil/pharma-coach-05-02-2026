import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class GeneralHelper {
  static String formatDateForApi(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  static String formatDateForDisplay1(DateTime date) {
    return DateFormat("EEE d-M-yyyy").format(date);
  }

  static DateTime getDateTimeFromApiVisitTime(String visitTime) {
    return DateTime.parse(visitTime.split(' ').first);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class GeneralHelper {
  static formatDateForApi(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  static formatDateForDisplay1(DateTime date) {
    return DateFormat("EEE d-M-yyyy").format(date);
  }

  static getDateTimeFromApiVisitTime(String visitTime) {
    return DateTime.parse(visitTime.split(' ').first);
  }
}

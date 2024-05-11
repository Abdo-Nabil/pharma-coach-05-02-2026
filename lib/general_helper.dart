import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'core/utils/pref_utils.dart';
import 'core/utils/progress_dialog_utils.dart';

class GeneralHelper {
  static String format = "yyyy-MM-dd";
  static String format2 = "yyyy-MM-dd HH:mm:ss";

  static String formatDateForApi(DateTime date) {
    return DateFormat(format).format(date);
  }

  static String formatAccurateDateForApi(DateTime date) {
    return DateFormat(format2).format(date);
  }

  static DateTime formatDateFromApi(String date) {
    return DateFormat(format).parse(date);
  }

  static String formatDateForDisplay1(DateTime date) {
    return DateFormat("EEE d-M-yyyy").format(date);
  }

  static String formatFromApiToDisplay(String date) {
    return formatDateForDisplay1(formatDateFromApi(date));
  }

  static DateTime getDateTimeFromApiVisitTime(String visitTime) {
    return DateTime.parse(visitTime.split(' ').first);
  }

  static Future<bool> canRemoveOrOverrideTodayIntendedVisit(
      BuildContext context, String date) async {
    final pref = PrefUtils();
    final result = pref.getFirstCategoryAnswer();
    // final result2 = pref.isLastQuestionTodayAnswered();
    if (result != null &&
        // result2 == false &&
        GeneralHelper.formatDateForApi(DateTime.now()) == date) {
      ProgressDialogUtils.showWarningDialog(
          context, "Sorry!", "You have already started the day");
      return true;
    }
    return false;
  }

  static int getQuarter(DateTime date) {
    late int q;
    if (date.month >= 1 && date.month <= 3) {
      q = 1;
    } else if (date.month >= 4 && date.month <= 6) {
      q = 2;
    } else if (date.month >= 7 && date.month <= 9) {
      q = 3;
    } else {
      q = 4;
    }
    return q;
  }
}

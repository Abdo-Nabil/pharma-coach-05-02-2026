import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'core/utils/pref_utils.dart';
import 'core/utils/progress_dialog_utils.dart';

class GeneralHelper {
  static String formatDateForApi(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  static DateTime formatDateFromApi(String date) {
    return DateFormat("yyyy-MM-dd").parse(date);
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
    final result2 = pref.isLastQuestionTodayAnswered();
    if (result != null &&
        result2 == false &&
        GeneralHelper.formatDateForApi(DateTime.now()) == date) {
      ProgressDialogUtils.showWarningDialog(
          context, "Sorry!", "You have already started the day");
      return true;
    }
    return false;
  }
}

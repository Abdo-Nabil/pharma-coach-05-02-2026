import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog(
      {BuildContext? context, isCancellable = false}) async {
    if (!isProgressVisible &&
        NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      showDialog(
          barrierDismissible: isCancellable,
          context: NavigatorService.navigatorKey.currentState!.overlay!.context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            );
          });
      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible)
      Navigator.pop(
          NavigatorService.navigatorKey.currentState!.overlay!.context);
    isProgressVisible = false;
  }

  static showErrorDialog(BuildContext context) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Ohh Sorry!',
        desc: 'Some thing went wrong, please contact us.',
        // btnCancelOnPress: () {},
        btnOkOnPress: () {},
        btnOk: SizedBox(
          height: 35,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ))
      ..show();
  }

  static showSuccessDialog(BuildContext context) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Thank You',
        desc: 'Your feedback has been submitted successfully',
        // btnCancelOnPress: () {},
        btnOkOnPress: () {},
        btnOk: SizedBox(
          height: 35,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ))
      ..show();
  }

  static showWarningDialog(BuildContext context) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Keep Note!',
        desc: 'Some questions were not answered',
        // btnCancelOnPress: () {},
        btnOkOnPress: () {},
        btnOk: SizedBox(
          height: 35,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ))
      ..show();
  }
}

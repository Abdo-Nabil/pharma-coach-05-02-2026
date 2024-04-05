import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/general_data.dart';

import '../../general_cubit/general_cubit.dart';
import '../../presentation/team_analytics_screen/team_analytics_screen.dart';

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

  static showSubmitSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Thank You',
      desc: 'Your feedback has been submitted successfully',
      // btnCancelColor: appTheme.orange300,
      // btnCancelText: "Next visit",
      // btnCancelOnPress: () {
      //   Navigator.pop(context);
      //   NavigatorService.popAndPushNamed(
      //     AppRoutes.listTabContainerScreen,
      //   );
      // },
      // btnOkText: "End of the day",
      // btnOkColor: appTheme.lightGreenA700,
      // btnOkOnPress: () {
      //   Navigator.pop(context);
      //   BlocProvider.of<GeneralCubit>(context).setBottomNavIndex(3);
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) {
      //       return TeamAnalyticsScreen.builder(context, isManualNav: true);
      //     }),
      //     (route) => false,
      //   );
      // },
      btnOk: SizedBox(
        height: 35,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            NavigatorService.popAndPushNamed(
              AppRoutes.listTabContainerScreen,
            );
          },
          child: Text("Next visit"),
        ),
      ),
      btnCancel: SizedBox(
        height: 35,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            Navigator.pop(context);
            BlocProvider.of<GeneralCubit>(context).setBottomNavIndex(3);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
                return TeamAnalyticsScreen.builder(context, isManualNav: true);
              }),
              (route) => false,
            );
          },
          child: Text("End of the day"),
        ),
      ),
    )..show();
  }

  static showWarningDialog(BuildContext context, String title, String body) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: title,
        desc: body,
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

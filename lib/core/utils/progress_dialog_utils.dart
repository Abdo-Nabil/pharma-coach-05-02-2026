import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/categories_data.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/general_helper.dart';

import '../../general_cubit/general_cubit.dart';
import '../../presentation/calendar_container_screen/cubit/calendar_cubit.dart';
import '../../presentation/calendar_container_screen/intended_visit_model.dart';
import '../../presentation/team_analytics_screen/team_analytics_screen.dart';
import '../../widgets/custom_elevated_button.dart';

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
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
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

        btnCancel: SizedBox(
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
        btnOk: SizedBox(
          height: 35,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              BlocProvider.of<GeneralCubit>(context).setBottomNavIndex(3);
              NavigatorService.popAndPushNamed(
                AppRoutes.teamAnalyticsScreen,
              );
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (context) {
              //     return TeamAnalyticsScreen.builder(context, isManualNav: true);
              //   }),
              //   (route) => false,
              // );
            },
            child: Text("End of the day"),
          ),
        ))
      ..show();
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

  static showCategoryInfo(BuildContext context, int categoryId) {
    debugPrint("cat id: $categoryId");
    if (categoryId > 12) {
      categoryId = categoryId - 12;
    }
    List body = categoriesData["$categoryId"];
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0.v, horizontal: 16.h),
        child: Column(
          children: List.generate(
            body.length,
            (index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 3.v),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "● ",
                      style: TextStyle(
                        fontSize: 16.fSize,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${body[index]}",
                        style: TextStyle(
                          fontSize: 16.fSize,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      // title: title,
      // desc: body,
      // // btnCancelOnPress: () {},
      // btnOkOnPress: () {},
      // btnOk: SizedBox(
      //   height: 35,
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: Text("OK"),
      //   ),
      // ),
    )..show();
  }

  static showEndOfTheDaySuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 313.h,
              padding: EdgeInsets.symmetric(
                horizontal: 13.h,
                vertical: 14.v,
              ),
              decoration: AppDecoration.fillOnPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder17,
              ),
              child: Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgXBlueGray900,
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                      alignment: Alignment.centerRight,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 9.v),
                    CustomImageView(
                      imagePath: ImageConstant.imgVector,
                      width: 112.h,
                    ),
                    SizedBox(height: 16.v),
                    Text(
                      "lbl_thank_you".tr,
                      style: CustomTextStyles.titleLargeBluegray900,
                    ),
                    SizedBox(height: 22.v),
                    Text(
                      "lbl_success".tr.toUpperCase(),
                      style: CustomTextStyles.titleLargeAmber700,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static showNextStepDialog(BuildContext context,
      {required Function onNextVisit, required Function onEndOfTheDay}) {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 313.h,
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 12.v,
              ),
              decoration: AppDecoration.fillOnPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder17,
              ),
              child: Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 57.h,
                        right: 2.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 21.v),
                            child: Text(
                              "msg_choose_your_next".tr,
                              style: CustomTextStyles.titleSmallBluegray900,
                            ),
                          ),
                          Spacer(),
                          CustomImageView(
                            imagePath: ImageConstant.imgXBlueGray900,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                            margin: EdgeInsets.only(
                              left: 31.h,
                              bottom: 15.v,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 19.v),
                    CustomElevatedButton(
                      text: "lbl_next_visit".tr,
                      margin: EdgeInsets.only(right: 2.h),
                      onPressed: () {
                        onNextVisit();
                      },
                    ),
                    SizedBox(height: 10.v),
                    CustomElevatedButton(
                      text: "lbl_end_of_the_day".tr,
                      margin: EdgeInsets.only(right: 2.h),
                      buttonStyle: CustomButtonStyles.fillPrimary,
                      onPressed: () {
                        onEndOfTheDay();
                      },
                    ),
                    SizedBox(height: 21.v),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static showRemoveIntendedVisitsDialog(BuildContext context,
      List<IntendedVisitModel> list, CalendarCubit calendarCubit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusStyle.roundedBorder17,
          ),
          title: Text(
            list[0].repName,
            style: TextStyle(
              fontSize: 17.fSize,
              color: appTheme.black900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              list.length,
              (index) {
                return ListTile(
                  title: Text(
                    GeneralHelper.formatFromApiToDisplay(
                        list[index].stringDate),
                    style: TextStyle(
                      fontSize: 15.fSize,
                      color: appTheme.black900.withOpacity(0.60),
                    ),
                  ),
                  trailing: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () async {
                    // await BlocProvider.of<CalendarCubit>(context)
                    final result =
                        await GeneralHelper.canRemoveOrOverrideIntendedVisit(
                            context, list[index].stringDate);
                    if (result) {
                      return;
                    }
                    await calendarCubit.removeIntendedVisit(list[index]);
                    Navigator.pop(context);
                  },
                );

/*
              return Padding(
                padding: EdgeInsets.fromLTRB(8.0.h, 0.0, 8.v, 20.v),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        list[index].stringDate,
                        style: TextStyle(
                          fontSize: 15.fSize,
                          color: appTheme.black900,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ],
                ),
              );
*/
              },
            ),
          ),
        );
      },
    );
  }
}

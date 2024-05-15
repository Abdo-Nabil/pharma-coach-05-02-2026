import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/presentation/questions_screen/cubit/questions_cubit.dart';
import 'package:mina_s_application5/presentation/questions_screen/last_question/last_build_category_with_questions.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/team_analytics_screen.dart';

import '../../../core/utils/size_utils.dart';
import '../../../general_cubit/general_cubit.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';

class LastQuestionScreen extends StatelessWidget {
  //
  onTapBack(BuildContext context) {
    Navigator.pop(context);
    BlocProvider.of<GeneralCubit>(context).setBottomNavIndex(1);
  }

  //
  @override
  Widget build(BuildContext context) {
    //

    //
    return WillPopScope(
      onWillPop: () async {
        onTapBack(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppBar(context),
          body: SizedBox(
            width: SizeUtils.width,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 16.v),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: Column(
                  children: [
/*
                    AnotherStepper(
                      stepperDirection: Axis.horizontal,
                      activeIndex: 0,
                      barThickness: 1,
                      inverted: true,
                      stepperList: [
                        // StepperData(),
                        StepperData(
                          iconWidget: SizedBox(
                            height: 12.adaptSize,
                            width: 12.adaptSize,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 12.adaptSize,
                                    width: 12.adaptSize,
                                    decoration: BoxDecoration(
                                      color: appTheme.teal50,
                                      borderRadius: BorderRadius.circular(
                                        6.h,
                                      ),
                                    ),
                                  ),
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgGroup36958,
                                  height: 12.adaptSize,
                                  width: 12.adaptSize,
                                  alignment: Alignment.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        StepperData(
                          iconWidget: SizedBox(
                            height: 12.adaptSize,
                            width: 12.adaptSize,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 12.adaptSize,
                                    width: 12.adaptSize,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(
                                        6.h,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 6.adaptSize,
                                    width: 6.adaptSize,
                                    margin: EdgeInsets.only(left: 2.h),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.onPrimary,
                                      borderRadius: BorderRadius.circular(
                                        3.h,
                                      ),
                                      border: Border.all(
                                        color: theme.colorScheme.onPrimary,
                                        width: 1.h,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: appTheme.gray50021,
                                          spreadRadius: 2.h,
                                          blurRadius: 2.h,
                                          offset: Offset(
                                            0,
                                            4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
*/
                    SizedBox(height: 8.v),
                    //
                    LastBuildCategoryWithQuestions(
                      categoryModel:
                          BlocProvider.of<QuestionsCubit>(context).lastCategory,
                    ),
                    SizedBox(height: 16.v),
                    CustomElevatedButton(
                      text: "lbl_submit".tr,
                      onPressed: () async {
                        if (BlocProvider.of<QuestionsCubit>(context)
                            .areAllLastCategoryQuestionsAnswered()) {
                          ProgressDialogUtils.showProgressDialog();
                          //
                          await BlocProvider.of<QuestionsCubit>(context)
                              .submitEndOfTheDay();
                          //
                          ProgressDialogUtils.hideProgressDialog();

                          ///
                          Navigator.pop(context);
                          BlocProvider.of<GeneralCubit>(context)
                              .setBottomNavIndex(3);
                          // ProgressDialogUtils.showEndOfTheDaySuccessDialog(
                          //     context);
                          //
                        } else {
                          ProgressDialogUtils.showWarningDialog(context,
                              'Keep Note!', 'Some questions are not answered');
                          return;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 4.v,
          bottom: 3.v,
        ),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarTitle(
        // text: "msg_medical_rep_s_name".tr,
        text: "",
      ),
    );
  }
}

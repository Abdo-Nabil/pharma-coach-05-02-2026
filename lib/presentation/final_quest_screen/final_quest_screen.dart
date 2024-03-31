import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_leading_image.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:mina_s_application5/widgets/custom_text_form_field.dart';
import 'package:mina_s_application5/widgets/custom_icon_button.dart';
import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
import 'models/final_quest_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/final_quest_bloc.dart';

class FinalQuestScreen extends StatelessWidget {
  const FinalQuestScreen({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<FinalQuestBloc>(
      create: (context) => FinalQuestBloc(FinalQuestState(
        finalQuestModelObj: FinalQuestModel(),
      ))
        ..add(FinalQuestInitialEvent()),
      child: FinalQuestScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  AnotherStepper(
                    stepperDirection: Axis.horizontal,
                    activeIndex: 0,
                    barThickness: 1,
                    inverted: true,
                    stepperList: [
                      StepperData(),
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
                  SizedBox(height: 24.v),
                  BlocSelector<FinalQuestBloc, FinalQuestState,
                      TextEditingController?>(
                    selector: (state) =>
                        state.coachingDaysFinalQuestionController,
                    builder: (context, coachingDaysFinalQuestionController) {
                      return CustomTextFormField(
                        controller: coachingDaysFinalQuestionController,
                        hintText: "msg_coaching_day_s_final".tr,
                        textInputAction: TextInputAction.done,
                        suffix: Container(
                          margin: EdgeInsets.fromLTRB(30.h, 8.v, 10.h, 8.v),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgInforectangleTeal50,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                          ),
                        ),
                        suffixConstraints: BoxConstraints(
                          maxHeight: 40.v,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 4.v),
                  _buildTimeAndTerritory(context),
                  SizedBox(height: 16.v),
                  CustomElevatedButton(
                    text: "lbl_submit".tr,
                  ),
                  SizedBox(height: 1353.v),
                  CustomElevatedButton(
                    text: "lbl_submit".tr,
                  ),
                ],
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
      ),
      centerTitle: true,
      title: AppbarTitle(
        text: "msg_medical_rep_s_name".tr,
      ),
    );
  }

  /// Section Widget
  Widget _buildTimeAndTerritory(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 13.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 115.h,
            margin: EdgeInsets.only(top: 1.v),
            child: Text(
              "msg_time_and_territory".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(top: 2.v),
            child: CustomIconButton(
              height: 35.adaptSize,
              width: 35.adaptSize,
              padding: EdgeInsets.all(5.h),
              decoration: IconButtonStyleHelper.outlineLightGreenATL8,
              child: CustomImageView(
                imagePath: ImageConstant.imgCheckLightGreenA70002,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 8.h,
              top: 2.v,
              right: 4.h,
            ),
            child: CustomIconButton(
              height: 35.adaptSize,
              width: 35.adaptSize,
              padding: EdgeInsets.all(5.h),
              decoration: IconButtonStyleHelper.outlineOnPrimaryContainer,
              child: CustomImageView(
                imagePath: ImageConstant.imgX,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

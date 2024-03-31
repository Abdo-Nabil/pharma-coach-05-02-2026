import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
import 'models/questions_one_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/questions_one_bloc.dart';

// ignore_for_file: must_be_immutable
class QuestionsOneDialog extends StatelessWidget {
  const QuestionsOneDialog({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<QuestionsOneBloc>(
      create: (context) => QuestionsOneBloc(QuestionsOneState(
        questionsOneModelObj: QuestionsOneModel(),
      ))
        ..add(QuestionsOneInitialEvent()),
      child: QuestionsOneDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 21.v),
                        child: Text(
                          "msg_choose_your_next".tr,
                          style: CustomTextStyles.titleSmallBluegray900,
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgXBlueGray900,
                        height: 24.adaptSize,
                        width: 24.adaptSize,
                        margin: EdgeInsets.only(
                          left: 31.h,
                          bottom: 15.v,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 19.v),
                CustomElevatedButton(
                  text: "lbl_next_visit".tr,
                  margin: EdgeInsets.only(right: 2.h),
                ),
                SizedBox(height: 10.v),
                CustomElevatedButton(
                  text: "lbl_end_of_the_day".tr,
                  margin: EdgeInsets.only(right: 2.h),
                  buttonStyle: CustomButtonStyles.fillPrimary,
                ),
                SizedBox(height: 21.v),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

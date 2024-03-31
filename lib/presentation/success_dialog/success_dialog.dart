import 'models/success_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/success_bloc.dart';

// ignore_for_file: must_be_immutable
class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<SuccessBloc>(
      create: (context) => SuccessBloc(SuccessState(
        successModelObj: SuccessModel(),
      ))
        ..add(SuccessInitialEvent()),
      child: SuccessDialog(),
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
  }
}

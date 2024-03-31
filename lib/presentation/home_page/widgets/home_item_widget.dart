import '../models/home_item_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

// ignore: must_be_immutable
class HomeItemWidget extends StatelessWidget {
  HomeItemWidget(
    this.homeItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  HomeItemModel homeItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 9.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 1.v),
          Text(
            homeItemModelObj.tareqFares!,
            style: CustomTextStyles.labelLargeSFProTextBluegray900,
          ),
          SizedBox(height: 3.v),
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgCalender,
                height: 10.adaptSize,
                width: 10.adaptSize,
                margin: EdgeInsets.only(bottom: 1.v),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.h),
                child: Text(
                  homeItemModelObj.oneMillionTwoHundredFiftyTwoTh!,
                  style: CustomTextStyles.bodySmall_1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

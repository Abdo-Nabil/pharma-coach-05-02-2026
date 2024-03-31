import '../models/calendarcontainer_item_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

// ignore: must_be_immutable
class CalendarcontainerItemWidget extends StatelessWidget {
  CalendarcontainerItemWidget(
    this.calendarcontainerItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  CalendarcontainerItemModel calendarcontainerItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 4.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder7,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      calendarcontainerItemModelObj.ahmedEssam!,
                      style: CustomTextStyles.bodySmallBlack90012,
                    ),
                    Container(
                      width: 14.adaptSize,
                      margin: EdgeInsets.only(left: 3.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.h,
                        vertical: 1.v,
                      ),
                      decoration: AppDecoration.fillPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder7,
                      ),
                      child: Text(
                        calendarcontainerItemModelObj.widget!,
                        style: CustomTextStyles.bodySmallOnPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.v),
                SizedBox(
                  width: 158.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        calendarcontainerItemModelObj.sun!,
                        style: CustomTextStyles.bodySmallGray500,
                      ),
                      Text(
                        calendarcontainerItemModelObj.th!,
                        style: CustomTextStyles.bodySmallGray500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgCheckedBox,
            height: 24.adaptSize,
            width: 24.adaptSize,
            margin: EdgeInsets.only(
              top: 3.v,
              right: 1.h,
              bottom: 4.v,
            ),
          ),
        ],
      ),
    );
  }
}

import '../models/listone_item_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

// ignore: must_be_immutable
class ListoneItemWidget extends StatelessWidget {
  ListoneItemWidget(
    this.listoneItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  ListoneItemModel listoneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillBlue.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listoneItemModelObj.elgawyHospital!,
                  style: CustomTextStyles.labelLargeSFProTextBluegray900,
                ),
                SizedBox(height: 3.v),
                Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgMapMarker,
                      height: 10.adaptSize,
                      width: 10.adaptSize,
                      margin: EdgeInsets.only(bottom: 2.v),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: Text(
                        listoneItemModelObj.nasrCityOne!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.v),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.h,
                    vertical: 3.v,
                  ),
                  decoration: AppDecoration.fillOnPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder3,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 9.adaptSize,
                        width: 9.adaptSize,
                        margin: EdgeInsets.symmetric(vertical: 1.v),
                        decoration: BoxDecoration(
                          color: appTheme.lightGreenA700,
                          borderRadius: BorderRadius.circular(
                            4.h,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.h),
                        child: Text(
                          listoneItemModelObj.normal!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 37.v),
            padding: EdgeInsets.symmetric(
              horizontal: 7.h,
              vertical: 3.v,
            ),
            decoration: AppDecoration.fillOnPrimary.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder3,
            ),
            child: Row(
              children: [
                Container(
                  height: 9.adaptSize,
                  width: 9.adaptSize,
                  margin: EdgeInsets.symmetric(vertical: 1.v),
                  decoration: BoxDecoration(
                    color: appTheme.blueGray100,
                    borderRadius: BorderRadius.circular(
                      4.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.h),
                  child: Text(
                    listoneItemModelObj.flash!,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

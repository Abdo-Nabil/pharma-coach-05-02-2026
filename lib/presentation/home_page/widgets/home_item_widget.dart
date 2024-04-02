import 'package:mina_s_application5/general_cubit/general_cubit.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/vsit_model.dart';

import '../models/home_item_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

// ignore: must_be_immutable
class HomeItemWidget extends StatelessWidget {
  HomeItemWidget(
    this.visitModel, {
    Key? key,
  }) : super(
          key: key,
        );

  VisitModel visitModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorService.pushNamed(AppRoutes.listTabContainerScreen);
      },
      child: Container(
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
            SizedBox(height: 3.v),
            // SizedBox(height: 300.v),
            Text(
              // homeItemModelObj.tareqFares!,
              "${visitModel.rep.firstName} ${visitModel.rep.lastName}",
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
                    // homeItemModelObj.oneMillionTwoHundredFiftyTwoTh!,
                    "${GeneralHelper.formatDateForDisplay1(GeneralHelper.getDateTimeFromApiVisitTime(visitModel.visitTime))}",
                    style: CustomTextStyles.bodySmall_1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

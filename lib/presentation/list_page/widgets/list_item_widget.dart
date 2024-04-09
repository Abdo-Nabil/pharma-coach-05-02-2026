import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/vsit_model.dart';

import '../models/list_item_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

// ignore: must_be_immutable
class ListItemWidget extends StatelessWidget {
  ListItemWidget(
    this.visitModel, {
    Key? key,
  }) : super(
          key: key,
        );

  VisitModel visitModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // listItemModelObj.marwaMohamedEldeeb!,
                  "${visitModel.rep.firstName}",
                  // "${visitModel.rep.firstName} ${visitModel.rep.lastName}",
                  style: CustomTextStyles.bodySmallBlack900,
                ),
                SizedBox(height: 4.v),
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
                        // listItemModelObj.brickNasrCity!,
                        "${visitModel.location.address}",
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.v),
                InkWell(
                  onTap: () {
                    GeneralData.selectedRepId = visitModel.rep.id!;
                    // GeneralData.selectedVisitId = visitModel.id;
                    NavigatorService.pushNamed(
                      AppRoutes.questionsScreen,
                      arguments: {
                        'type': 'normal',
                        'visitId': visitModel.id,
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.h,
                      vertical: 3.v,
                    ),
                    decoration: AppDecoration.fillGray.copyWith(
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
                            "Normal",
                            // listItemModelObj.normal!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.v),
            child: Column(
              children: [
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: Text(
                //     listItemModelObj.paediatrics!,
                //     style: CustomTextStyles.bodySmallAmber700,
                //   ),
                // ),
                // SizedBox(height: 19.v),
                InkWell(
                  onTap: () {
                    GeneralData.selectedRepId = visitModel.rep.id!;
                    // GeneralData.selectedVisitId = visitModel.id;
                    NavigatorService.pushNamed(
                      AppRoutes.questionsScreen,
                      arguments: {
                        'type': 'flash',
                        'visitId': visitModel.id,
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 37.v),
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.h,
                      vertical: 3.v,
                    ),
                    decoration: AppDecoration.fillGray.copyWith(
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
                            color: appTheme.orange300,
                            // color: appTheme.blueGray100,
                            borderRadius: BorderRadius.circular(
                              4.h,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.h),
                          child: Text(
                            "Flash",
                            // listItemModelObj.flash!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
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

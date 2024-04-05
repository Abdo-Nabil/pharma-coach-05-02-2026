import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../calendar_container_screen/models/location_model.dart';
import 'cubit/add_medical_rep_cubit.dart';

class LocationDialogItem extends StatelessWidget {
  final LocationModel locationModel;
  const LocationDialogItem({
    required this.locationModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<AddMedicalRepCubit>(context)
            .setLocationIdAndShowSubmit(locationModel.id!);
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 16.h,
          right: 10.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 6.h,
          vertical: 4.v,
        ),
        decoration: AppDecoration.fillGray.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder3,
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              // padding: EdgeInsets.only(left: 6.h),
              padding: EdgeInsets.symmetric(vertical: 10.v, horizontal: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationModel.name,
                    // "lbl_ahmed_essam".tr,
                    style: CustomTextStyles.bodySmallBlack90012,
                  ),
                  SizedBox(height: 6.v),
                  Text(
                    locationModel.address,
                    // "lbl_ahmed_essam".tr,
                    style: CustomTextStyles.bodySmallAmber700,
                  ),
                  // SizedBox(height: 4.v),
                  // Text(
                  //   "lbl_sun_20_5_2024".tr,
                  //   style: CustomTextStyles.bodySmallGray500,
                  // ),
                ],
              ),
            ),
            // CustomImageView(
            //   imagePath: ImageConstant.imgCheckedBox,
            //   height: 24.adaptSize,
            //   width: 24.adaptSize,
            //   margin: EdgeInsets.symmetric(vertical: 3.v),
            // ),
          ],
        ),
      ),
    );
  }
}

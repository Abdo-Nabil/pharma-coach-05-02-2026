import 'package:mina_s_application5/widgets/custom_search_view.dart';
import 'models/add_medical_rep_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/add_medical_rep_bloc.dart';

// ignore_for_file: must_be_immutable
class AddMedicalRepDialog extends StatelessWidget {
  const AddMedicalRepDialog({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<AddMedicalRepBloc>(
      create: (context) => AddMedicalRepBloc(AddMedicalRepState(
        addMedicalRepModelObj: AddMedicalRepModel(),
      ))
        ..add(AddMedicalRepInitialEvent()),
      child: AddMedicalRepDialog(),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(left: 84.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.v),
                          child: Text(
                            "lbl_add_medical_rep".tr,
                            style: CustomTextStyles.titleSmallBlack900,
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgXBlueGray900,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                          margin: EdgeInsets.only(
                            left: 59.h,
                            bottom: 2.v,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.v),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.h,
                    right: 8.h,
                  ),
                  child: BlocSelector<AddMedicalRepBloc, AddMedicalRepState,
                      TextEditingController?>(
                    selector: (state) => state.searchController,
                    builder: (context, searchController) {
                      return CustomSearchView(
                        controller: searchController,
                        hintText: "lbl_search".tr,
                        borderDecoration: SearchViewStyleHelper.fillGray,
                        fillColor: appTheme.gray100,
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.v),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.h),
                    child: Text(
                      "lbl_recent".tr,
                      style: CustomTextStyles.bodySmallPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 3.v),
                Container(
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 6.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "lbl_ahmed_essam".tr,
                              style: CustomTextStyles.bodySmallBlack90012,
                            ),
                            SizedBox(height: 4.v),
                            Text(
                              "lbl_sun_20_5_2024".tr,
                              style: CustomTextStyles.bodySmallGray500,
                            ),
                          ],
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgCheckedBox,
                        height: 24.adaptSize,
                        width: 24.adaptSize,
                        margin: EdgeInsets.symmetric(vertical: 3.v),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.v),
                Container(
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 6.h),
                        child: Column(
                          children: [
                            Text(
                              "lbl_mona_ahmed".tr,
                              style: CustomTextStyles.bodySmallBlack90012,
                            ),
                            SizedBox(height: 4.v),
                            Text(
                              "lbl_sun_20_5_2024".tr,
                              style: CustomTextStyles.bodySmallGray500,
                            ),
                          ],
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgCheckedBox,
                        height: 24.adaptSize,
                        width: 24.adaptSize,
                        margin: EdgeInsets.only(
                          top: 2.v,
                          bottom: 4.v,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 13.v),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

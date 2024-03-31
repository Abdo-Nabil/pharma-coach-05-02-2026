import 'package:mina_s_application5/presentation/home_page/home_page.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
import 'package:mina_s_application5/widgets/custom_drop_down.dart';
import 'models/team_analytics_model.dart';
import 'package:mina_s_application5/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/team_analytics_bloc.dart';

class TeamAnalyticsScreen extends StatelessWidget {
  TeamAnalyticsScreen({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Widget builder(BuildContext context) {
    return BlocProvider<TeamAnalyticsBloc>(
      create: (context) => TeamAnalyticsBloc(TeamAnalyticsState(
        teamAnalyticsModelObj: TeamAnalyticsModel(),
      ))
        ..add(TeamAnalyticsInitialEvent()),
      child: TeamAnalyticsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 4.v,
          ),
          child: Column(
            children: [
              CustomElevatedButton(
                height: 40.v,
                text: "lbl_team".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
              ),
              SizedBox(height: 8.v),
              BlocSelector<TeamAnalyticsBloc, TeamAnalyticsState,
                  TeamAnalyticsModel?>(
                selector: (state) => state.teamAnalyticsModelObj,
                builder: (context, teamAnalyticsModelObj) {
                  return CustomDropDown(
                    icon: Container(
                      margin: EdgeInsets.fromLTRB(30.h, 8.v, 14.h, 9.v),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgArrowdown,
                        height: 24.adaptSize,
                        width: 24.adaptSize,
                      ),
                    ),
                    hintText: "msg_choose_medical_rep".tr,
                    items: teamAnalyticsModelObj?.dropdownItemList ?? [],
                  );
                },
              ),
              SizedBox(height: 8.v),
              _buildPersonalAttributes(context),
              SizedBox(height: 8.v),
              _buildSCORE(context),
              SizedBox(height: 12.v),
              CustomElevatedButton(
                text: "lbl_save_as_svg".tr,
                rightIcon: Container(
                  margin: EdgeInsets.only(left: 4.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgDownload,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                  ),
                ),
              ),
              SizedBox(height: 5.v),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 36.v,
      title: AppbarTitle(
        text: "lbl_analytics".tr,
        margin: EdgeInsets.only(left: 16.h),
      ),
      actions: [
        AppbarTrailingIconbuttonOne(
          imagePath: ImageConstant.imgGoogleAnalyticsDeepOrange50,
          margin: EdgeInsets.only(
            left: 16.h,
            top: 2.v,
            right: 1.h,
          ),
        ),
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgUsersOnprimary,
          margin: EdgeInsets.only(
            left: 6.h,
            top: 2.v,
            right: 17.h,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildPersonalAttributes(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 13.h,
        vertical: 15.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "msg_personal_attributes".tr,
            style: CustomTextStyles.bodySmallStylishSecondaryContainer,
          ),
          Container(
            decoration: AppDecoration.fillBlue100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 140.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.v,
                    right: 6.h,
                  ),
                  child: Text(
                    "lbl_302".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.v),
          Container(
            decoration: AppDecoration.fillPurple.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 184.h,
                  decoration: BoxDecoration(
                    color: appTheme.purple300,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.v,
                    right: 6.h,
                  ),
                  child: Text(
                    "lbl_55".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.v),
          Text(
            "msg_pharmacy_feedback2".tr,
            style: theme.textTheme.labelMedium,
          ),
          SizedBox(height: 2.v),
          Container(
            decoration: AppDecoration.fillBlue100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 89.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.v,
                    right: 8.h,
                  ),
                  child: Text(
                    "lbl_15".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.v),
          Container(
            decoration: AppDecoration.fillPurple.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 16.v,
                  width: 236.h,
                  decoration: BoxDecoration(
                    color: appTheme.purple300,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 53.h,
                    top: 2.v,
                  ),
                  child: Text(
                    "lbl_80".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 9.v),
          Text(
            "msg_personal_attributes".tr,
            style: theme.textTheme.labelMedium,
          ),
          SizedBox(height: 3.v),
          Container(
            decoration: AppDecoration.fillBlue100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 140.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.v,
                    right: 6.h,
                  ),
                  child: Text(
                    "lbl_302".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.v),
          Container(
            decoration: AppDecoration.fillPurple.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 184.h,
                  decoration: BoxDecoration(
                    color: appTheme.purple300,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.v,
                    right: 6.h,
                  ),
                  child: Text(
                    "lbl_55".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.v),
          Text(
            "msg_pharmacy_feedback2".tr,
            style: theme.textTheme.labelMedium,
          ),
          SizedBox(height: 2.v),
          Container(
            decoration: AppDecoration.fillBlue100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 89.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.v,
                    right: 8.h,
                  ),
                  child: Text(
                    "lbl_15".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.v),
          Container(
            decoration: AppDecoration.fillPurple.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 16.v,
                  width: 236.h,
                  decoration: BoxDecoration(
                    color: appTheme.purple300,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 53.h,
                    top: 2.v,
                  ),
                  child: Text(
                    "lbl_80".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.v),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSCORE(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 13.h,
        vertical: 11.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_score".tr,
            style: theme.textTheme.labelMedium,
          ),
          SizedBox(height: 3.v),
          Container(
            decoration: AppDecoration.fillBlue100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 169.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.v,
                    right: 5.h,
                  ),
                  child: Text(
                    "lbl_60".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.v),
          Container(
            decoration: AppDecoration.fillPurple.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 205.h,
                  decoration: BoxDecoration(
                    color: appTheme.purple300,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.v,
                    right: 6.h,
                  ),
                  child: Text(
                    "lbl_70".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(
      onChanged: (BottomBarEnum type) {
        Navigator.pushNamed(
            navigatorKey.currentContext!, getCurrentRoute(type));
      },
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homePage;
      case BottomBarEnum.List:
        return "/";
      case BottomBarEnum.Calendar:
        return "/";
      case BottomBarEnum.Analytics:
        return "/";
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(
    BuildContext context,
    String currentRoute,
  ) {
    switch (currentRoute) {
      case AppRoutes.homePage:
        return HomePage.builder(context);
      default:
        return DefaultWidget();
    }
  }
}

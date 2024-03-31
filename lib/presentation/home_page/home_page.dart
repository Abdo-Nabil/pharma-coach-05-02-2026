import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title_image.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'widgets/home_item_widget.dart';
import 'models/home_item_model.dart';
import 'models/home_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/home_bloc.dart'; // ignore_for_file: must_be_immutable

class HomePage extends StatelessWidget {
  const HomePage({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(HomeState(
        homeModelObj: HomeModel(),
      ))
        ..add(HomeInitialEvent()),
      child: HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillGray,
          child: Column(
            children: [
              _buildPharcoCorpLogo(context),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 13.h,
                  vertical: 21.v,
                ),
                child: Column(
                  children: [
                    _buildYourPlan(context),
                    SizedBox(height: 8.v),
                    _buildHome(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPharcoCorpLogo(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            title: AppbarTitleImage(
              imagePath: ImageConstant.imgPharcoCorpLogo,
              margin: EdgeInsets.only(left: 17.h),
            ),
            actions: [
              AppbarTrailingIconbutton(
                imagePath: ImageConstant.imgCalendarText,
                margin: EdgeInsets.only(
                  left: 16.h,
                  right: 16.h,
                  bottom: 3.v,
                ),
              )
            ],
          ),
          SizedBox(height: 11.v),
          Container(
            width: 97.h,
            margin: EdgeInsets.only(left: 17.h),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "lbl_welcome_back".tr,
                    style: CustomTextStyles.bodySmallff63656a,
                  ),
                  TextSpan(
                    text: "lbl_hasnaa_ahmed".tr,
                    style: CustomTextStyles.labelLargeSFProTextff017cba,
                  )
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 28.v)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildYourPlan(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4.h,
        right: 1.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "lbl_your_plan".tr,
            style: CustomTextStyles.labelLargeSFProTextBluegray900SemiBold,
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.v),
            child: Text(
              "lbl_show_all".tr,
              style: theme.textTheme.bodySmall,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildHome(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: BlocSelector<HomeBloc, HomeState, HomeModel?>(
        selector: (state) => state.homeModelObj,
        builder: (context, homeModelObj) {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 8.v,
              );
            },
            itemCount: homeModelObj?.homeItemList.length ?? 0,
            itemBuilder: (context, index) {
              HomeItemModel model =
                  homeModelObj?.homeItemList[index] ?? HomeItemModel();
              return HomeItemWidget(
                model,
              );
            },
          );
        },
      ),
    );
  }
}

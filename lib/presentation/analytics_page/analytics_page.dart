import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
import 'models/analytics_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/analytics_bloc.dart';

// ignore_for_file: must_be_immutable
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key})
      : super(
          key: key,
        );

  @override
  AnalyticsPageState createState() => AnalyticsPageState();
  static Widget builder(BuildContext context) {
    return BlocProvider<AnalyticsBloc>(
      create: (context) => AnalyticsBloc(AnalyticsState(
        analyticsModelObj: AnalyticsModel(),
      ))
        ..add(AnalyticsInitialEvent()),
      child: AnalyticsPage(),
    );
  }
}

class AnalyticsPageState extends State<AnalyticsPage>
    with AutomaticKeepAliveClientMixin<AnalyticsPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              width: double.maxFinite,
              decoration: AppDecoration.fillGray,
              child: Column(
                children: [
                  SizedBox(height: 4.v),
                  _buildSaveAsSVG(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildSaveAsSVG(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 13.h,
              vertical: 22.v,
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
                SizedBox(height: 8.v),
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
                        width: 175.h,
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
                SizedBox(height: 44.v),
              ],
            ),
          ),
          SizedBox(height: 8.v),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 13.h,
              vertical: 10.v,
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
                  decoration: AppDecoration.fillOrange.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder7,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 16.v,
                        width: 175.h,
                        decoration: BoxDecoration(
                          color: appTheme.amber700,
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
                SizedBox(height: 5.v),
              ],
            ),
          ),
          SizedBox(height: 15.v),
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
        ],
      ),
    );
  }
}

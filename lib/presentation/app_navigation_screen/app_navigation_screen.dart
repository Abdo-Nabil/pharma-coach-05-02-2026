import '../questions_one_dialog/questions_one_dialog.dart';
import '../success_dialog/success_dialog.dart';
import '../add_medical_rep_dialog/add_medical_rep_dialog.dart';
import 'models/app_navigation_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/app_navigation_bloc.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<AppNavigationBloc>(
      create: (context) => AppNavigationBloc(AppNavigationState(
        appNavigationModelObj: AppNavigationModel(),
      ))
        ..add(AppNavigationInitialEvent()),
      child: AppNavigationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppNavigationBloc, AppNavigationState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Color(0XFFFFFFFF),
            body: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  _buildAppNavigation(context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFFFFFFF),
                        ),
                        child: Column(
                          children: [
                            _buildScreenTitle(
                              context,
                              screenTitle: "On boarding".tr,
                              onTapScreenTitle: () =>
                                  onTapScreenTitle(AppRoutes.onBoardingScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "Sign in propsal One".tr,
                              onTapScreenTitle: () => onTapScreenTitle(
                                  AppRoutes.signInPropsalOneScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "home - Container".tr,
                              onTapScreenTitle: () => onTapScreenTitle(
                                  AppRoutes.homeContainerScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "List - Tab Container".tr,
                              onTapScreenTitle: () => onTapScreenTitle(
                                  AppRoutes.listTabContainerScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "Questions".tr,
                              onTapScreenTitle: () =>
                                  onTapScreenTitle(AppRoutes.questionsScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "Questions One - Dialog".tr,
                              onTapScreenTitle: () => onTapDialogTitle(
                                  context, QuestionsOneDialog.builder(context)),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "final quest".tr,
                              onTapScreenTitle: () =>
                                  onTapScreenTitle(AppRoutes.finalQuestScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "success - Dialog".tr,
                              onTapScreenTitle: () => onTapDialogTitle(
                                  context, SuccessDialog.builder(context)),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "calendar - Container".tr,
                              onTapScreenTitle: () => onTapScreenTitle(
                                  AppRoutes.calendarContainerScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "add medical rep - Dialog".tr,
                              onTapScreenTitle: () => onTapDialogTitle(context,
                                  AddMedicalRepDialog.builder(context)),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "analytics - Tab Container".tr,
                              onTapScreenTitle: () => onTapScreenTitle(
                                  AppRoutes.analyticsTabContainerScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "team analytics".tr,
                              onTapScreenTitle: () => onTapScreenTitle(
                                  AppRoutes.teamAnalyticsScreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildAppNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                "App Navigation".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "Check your app's UI from the below demo screens of your app."
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF888888),
                  fontSize: 16.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: Color(0XFF000000),
          ),
        ],
      ),
    );
  }

  /// Common click event for dialog
  void onTapDialogTitle(
    BuildContext context,
    Widget className,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return className;
      },
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.v),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Text(
                  screenTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF000000),
                    fontSize: 20.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.v),
            SizedBox(height: 5.v),
            Divider(
              height: 1.v,
              thickness: 1.v,
              color: Color(0XFF888888),
            ),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(String routeName) {
    NavigatorService.pushNamed(routeName);
  }
}

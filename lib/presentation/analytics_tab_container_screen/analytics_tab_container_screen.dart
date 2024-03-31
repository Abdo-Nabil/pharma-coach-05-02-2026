import 'package:mina_s_application5/presentation/home_page/home_page.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import 'package:mina_s_application5/presentation/analytics_page/analytics_page.dart';
import 'package:mina_s_application5/widgets/custom_bottom_bar.dart';
import 'models/analytics_tab_container_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/analytics_tab_container_bloc.dart';

class AnalyticsTabContainerScreen extends StatefulWidget {
  const AnalyticsTabContainerScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AnalyticsTabContainerScreenState createState() =>
      AnalyticsTabContainerScreenState();
  static Widget builder(BuildContext context) {
    return BlocProvider<AnalyticsTabContainerBloc>(
      create: (context) => AnalyticsTabContainerBloc(AnalyticsTabContainerState(
        analyticsTabContainerModelObj: AnalyticsTabContainerModel(),
      ))
        ..add(AnalyticsTabContainerInitialEvent()),
      child: AnalyticsTabContainerScreen(),
    );
  }
}

class AnalyticsTabContainerScreenState
    extends State<AnalyticsTabContainerScreen> with TickerProviderStateMixin {
  late TabController tabviewController;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsTabContainerBloc, AnalyticsTabContainerState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(height: 4.v),
                  _buildTabview(context),
                  SizedBox(
                    height: 614.v,
                    child: TabBarView(
                      controller: tabviewController,
                      children: [
                        AnalyticsPage.builder(context),
                        AnalyticsPage.builder(context),
                        AnalyticsPage.builder(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomBar(context),
          ),
        );
      },
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
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgGoogleAnalytics,
          margin: EdgeInsets.only(
            left: 16.h,
            top: 2.v,
            right: 1.h,
          ),
        ),
        AppbarTrailingIconbuttonOne(
          imagePath: ImageConstant.imgUsers,
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
  Widget _buildTabview(BuildContext context) {
    return Container(
      height: 40.v,
      width: 344.h,
      child: TabBar(
        controller: tabviewController,
        labelPadding: EdgeInsets.zero,
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: appTheme.gray400,
        tabs: [
          Tab(
            child: Text(
              "lbl_today".tr,
            ),
          ),
          Tab(
            child: Text(
              "lbl_monthly".tr,
            ),
          ),
          Tab(
            child: Text(
              "lbl_quarter".tr,
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

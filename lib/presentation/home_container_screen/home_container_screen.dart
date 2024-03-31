import 'package:mina_s_application5/presentation/home_page/home_page.dart';
import 'package:mina_s_application5/presentation/list_one_page/list_one_page.dart';
import 'package:mina_s_application5/presentation/list_page/list_page.dart';
import 'package:mina_s_application5/widgets/custom_bottom_bar.dart';
import '../calendar_container_screen/calendar_container_screen.dart';
import '../list_tab_container_screen/list_tab_container_screen.dart';
import 'models/home_container_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/home_container_bloc.dart';

// ignore_for_file: must_be_immutable
class HomeContainerScreen extends StatelessWidget {
  HomeContainerScreen({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Widget builder(BuildContext context) {
    return BlocProvider<HomeContainerBloc>(
      create: (context) => HomeContainerBloc(HomeContainerState(
        homeContainerModelObj: HomeContainerModel(),
      ))
        ..add(HomeContainerInitialEvent()),
      child: HomeContainerScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContainerBloc, HomeContainerState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Navigator(
              key: navigatorKey,
              initialRoute: AppRoutes.homePage,
              onGenerateRoute: (routeSetting) => PageRouteBuilder(
                pageBuilder: (ctx, ani, ani1) =>
                    getCurrentPage(context, routeSetting.name!),
                transitionDuration: Duration(seconds: 0),
              ),
            ),
            bottomNavigationBar: _buildBottomBar(context),
          ),
        );
      },
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
        return AppRoutes.listTabContainerScreen;
      case BottomBarEnum.Calendar:
          return AppRoutes.calendarContainerScreen;
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
      case AppRoutes.listTabContainerScreen:
        return ListTabContainerScreen.builder(context);
      case AppRoutes.calendarContainerScreen:
        return CalendarContainerScreen.builder(context);
      default:
        return DefaultWidget();
    }
  }
}

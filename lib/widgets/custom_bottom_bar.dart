import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

import '../core/utils/progress_dialog_utils.dart';
import '../general_cubit/general_cubit.dart';

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  // int selectedIndex = 0;
  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgNavHome,
      activeIcon: ImageConstant.imgNavHome,
      title: "lbl_home".tr,
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavList,
      activeIcon: ImageConstant.imgNavList,
      title: "lbl_list".tr,
      type: BottomBarEnum.List,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavCalendar,
      activeIcon: ImageConstant.imgNavCalendar,
      title: "lbl_calendar".tr,
      type: BottomBarEnum.Calendar,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavAnalytics,
      activeIcon: ImageConstant.imgNavAnalytics,
      title: "lbl_analytics".tr,
      type: BottomBarEnum.Analytics,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavLogout,
      activeIcon: ImageConstant.imgNavLogout,
      title: "lbl_logout".tr,
      type: BottomBarEnum.Logout,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.v,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        // currentIndex: selectedIndex,
        currentIndex:
            BlocProvider.of<GeneralCubit>(context, listen: true).bottomNavIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: bottomMenuList[index].icon,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  color: index == bottomMenuList.length - 1
                      ? Colors.red
                      : appTheme.amber700,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.bodySmallGray300.copyWith(
                      color: index == bottomMenuList.length - 1
                          ? Colors.red
                          : appTheme.amber700,
                    ),
                  ),
                ),
              ],
            ),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: bottomMenuList[index].activeIcon,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  color: appTheme.darkBlue,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.bodySmallAmber7008.copyWith(
                      color: appTheme.darkBlue,
                    ),
                  ),
                ),
              ],
            ),
            label: '',
          );
        }),
        onTap: (index) {
          /// Logout tab
          if (index == bottomMenuList.length - 1) {
            ProgressDialogUtils.showLogoutDialog(
              context,
              () async {
                final shared = PrefUtils();
                await shared.clearToken();
                // shared.clearPreferencesData();
                NavigatorService.popAndPushNamed(
                  AppRoutes.signInPropsalOneScreen,
                );
              },
            );
            return;
          }
          BlocProvider.of<GeneralCubit>(context).setBottomNavIndex(index);
          // widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

enum BottomBarEnum {
  Home,
  List,
  Calendar,
  Analytics,
  Logout,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });

  String icon;

  String activeIcon;

  String? title;

  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

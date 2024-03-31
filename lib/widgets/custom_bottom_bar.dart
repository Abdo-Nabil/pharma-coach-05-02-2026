import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

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
    )
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
        currentIndex: selectedIndex,
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
                  color: appTheme.gray300,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.bodySmallGray300.copyWith(
                      color: appTheme.gray300,
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
                  color: appTheme.amber700,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.bodySmallAmber7008.copyWith(
                      color: appTheme.amber700,
                    ),
                  ),
                ),
              ],
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
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

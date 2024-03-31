import 'package:mina_s_application5/presentation/home_page/home_page.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'widgets/calendarcontainer_item_widget.dart';
import 'models/calendarcontainer_item_model.dart';
import 'models/calendar_container_model.dart';
import 'package:mina_s_application5/widgets/custom_bottom_bar.dart';
import 'package:mina_s_application5/widgets/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/calendar_container_bloc.dart';

class CalendarContainerScreen extends StatelessWidget {
  CalendarContainerScreen({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Widget builder(BuildContext context) {
    return BlocProvider<CalendarContainerBloc>(
      create: (context) => CalendarContainerBloc(CalendarContainerState(
        calendarContainerModelObj: CalendarContainerModel(),
      ))
        ..add(CalendarContainerInitialEvent()),
      child: CalendarContainerScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.v),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  children: [
                    _buildCalendar(context),
                    SizedBox(height: 11.v),
                    _buildCalendarContainer(context),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),

        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 33.v,
      title: AppbarTitle(
        text: "lbl_calendar".tr,
        margin: EdgeInsets.only(left: 16.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildCalendar(BuildContext context) {
    return BlocBuilder<CalendarContainerBloc, CalendarContainerState>(
      builder: (context, state) {
        return SizedBox(
          height: 326.v,
          width: 343.h,
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.range,
              rangeBidirectional: true,
              firstDate: DateTime(DateTime.now().year - 5),
              lastDate: DateTime(DateTime.now().year + 5),
              firstDayOfWeek: 1,
              weekdayLabelTextStyle: TextStyle(
                color: appTheme.black900,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
              ),
              selectedDayTextStyle: TextStyle(
                color: Color(0XFF000000),
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w400,
              ),
              dayTextStyle: TextStyle(
                color: appTheme.black900,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w400,
              ),
              disabledDayTextStyle: TextStyle(
                color: appTheme.gray400,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w400,
              ),
              weekdayLabels: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
            ),
            value: state.selectedDatesFromCalendar1 ?? [],
            onValueChanged: (dates) {
              state.selectedDatesFromCalendar1 = dates;
            },
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildCalendarContainer(BuildContext context) {
    return BlocSelector<CalendarContainerBloc, CalendarContainerState,
        CalendarContainerModel?>(
      selector: (state) => state.calendarContainerModelObj,
      builder: (context, calendarContainerModelObj) {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (
            context,
            index,
          ) {
            return SizedBox(
              height: 4.v,
            );
          },
          itemCount:
              calendarContainerModelObj?.calendarcontainerItemList.length ?? 0,
          itemBuilder: (context, index) {
            CalendarcontainerItemModel model =
                calendarContainerModelObj?.calendarcontainerItemList[index] ??
                    CalendarcontainerItemModel();
            return CalendarcontainerItemWidget(
              model,
            );
          },
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

  /// Section Widget
  Widget _buildFloatingActionButton(BuildContext context) {
    return CustomFloatingButton(
      height: 50,
      width: 50,
      backgroundColor: appTheme.amber700,
      child: CustomImageView(
        imagePath: ImageConstant.imgXOnprimary,
        height: 25.0.v,
        width: 25.0.h,
      ),
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

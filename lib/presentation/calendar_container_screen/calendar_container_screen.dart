import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/add_medical_rep_dialog/add_medical_rep_dialog.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/cubit/calendar_cubit.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/widgets/calendar_widget.dart';
import 'package:mina_s_application5/presentation/home_page/home_page.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/custom_bottom_bar.dart';
import 'package:mina_s_application5/widgets/custom_floating_button.dart';

import 'bloc/calendar_container_bloc.dart';
import 'models/calendar_container_model.dart';
import 'models/calendarcontainer_item_model.dart';
import 'widgets/calendar_container_item_widget.dart';

class CalendarContainerScreen extends StatefulWidget {
  CalendarContainerScreen({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<CalendarCubit>(
      create: (context) {
        GeneralData.calendarCubit = CalendarCubit(apiClient: ApiClient());
        return GeneralData.calendarCubit;
      },
      // create: (context) => CalendarCubit(apiClient: ApiClient()),
      child: CalendarContainerScreen(),
    );
  }

  @override
  State<CalendarContainerScreen> createState() =>
      _CalendarContainerScreenState();
}

class _CalendarContainerScreenState extends State<CalendarContainerScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    // BlocProvider.of<CalendarCubit>(context)
    //     .getMonthlyVisits(GeneralHelper.formatDateForApi(DateTime.now()));
    // BlocProvider.of<CalendarCubit>(context).getMonthlyIntendedVisits();
    BlocProvider.of<CalendarCubit>(context).getData();
    super.initState();
  }

  // static Widget builder(BuildContext context) {
  @override
  Widget build(BuildContext context) {
    Future(ProgressDialogUtils.showProgressDialog);
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocListener<CalendarCubit, CalendarState>(
          listener: (context, state) {
            if (state is CalendarLoading) {
              ProgressDialogUtils.showProgressDialog();
            } else if (state is CalendarSuccess) {
              ProgressDialogUtils.hideProgressDialog();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8.v),
                  CalendarWidget(),
                ],
              ),
            ),
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
            return CalendarContainerItemWidget(
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
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onTap: () async {
        DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
        // if (GeneralData.selectedDate.weekday == DateTime.thursday) {
        //   ProgressDialogUtils.showWarningDialog(
        //       context, "Sorry!", "You can't create visits on thursday");
        //   return;
        // }
        //TODO:///////////////////////////////////////////////////////
        if (GeneralData.selectedDate.weekday == DateTime.friday) {
          ProgressDialogUtils.showWarningDialog(
              context, "Sorry!", "You can't create visits on friday");
          return;
        } else if (GeneralData.selectedDate.isBefore(yesterday)) {
          ProgressDialogUtils.showWarningDialog(
              context, "Sorry!", "You can't create visits in the past");
          return;
        }
        //
        final result =
            await GeneralHelper.canRemoveOrOverrideTodayIntendedVisit(context,
                GeneralHelper.formatDateForApi(GeneralData.selectedDate));
        if (result) {
          return;
        }

        //
        showDialog(
          context: context,
          builder: (context) {
            return AddMedicalRepDialog.builder(context,
                isNSM: GeneralData.isNSM());
          },
        );
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

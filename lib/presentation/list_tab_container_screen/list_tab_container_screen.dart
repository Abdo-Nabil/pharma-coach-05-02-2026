import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/presentation/home_page/home_page.dart';
import 'package:mina_s_application5/presentation/list_tab_container_screen/cubit/list_tap_container_cubit.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:mina_s_application5/presentation/list_page/list_page.dart';
import 'package:mina_s_application5/presentation/list_one_page/list_one_page.dart';
import 'package:mina_s_application5/widgets/custom_bottom_bar.dart';
import 'models/list_tab_container_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/list_tab_container_bloc.dart';

class ListTabContainerScreen extends StatefulWidget {
  const ListTabContainerScreen({Key? key})
      : super(
          key: key,
        );

  @override
  ListTabContainerScreenState createState() => ListTabContainerScreenState();

  //
  // static Widget builder(BuildContext context) {
  //   return BlocProvider<ListTabContainerBloc>(
  //     create: (context) => ListTabContainerBloc(ListTabContainerState(
  //       listTabContainerModelObj: ListTabContainerModel(),
  //     ))
  //       ..add(ListTabContainerInitialEvent()),
  //     child: ListTabContainerScreen(),
  //   );
  // }
  static Widget builder(BuildContext context) {
    return BlocProvider<ListTabContainerCubit>(
      create: (context) => ListTabContainerCubit(ApiClient()),
      child: ListTabContainerScreen(),
    );
  }
}

class ListTabContainerScreenState extends State<ListTabContainerScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
    BlocProvider.of<ListTabContainerCubit>(context).getAmAndPmVisits();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListTabContainerCubit, ListTapContainerState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: BlocBuilder<ListTabContainerCubit, ListTapContainerState>(
              builder: (context, state) {
                if (state is ListTapContainerLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                //
                else if (state is ListTapContainerGetVisitSuccessState) {
                  return SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 5.v),
                          _buildTabview(context),
                          SizedBox(
                            height: 614.v,
                            child: TabBarView(
                              controller: tabviewController,
                              children: [
                                ListPage.builder(context),
                                ListOnePage.builder(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            // bottomNavigationBar: _buildBottomBar(context),
          ),
        );
      },
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 35.v,
      title: AppbarTitle(
        text: "msg_medical_rep_list".tr,
        margin: EdgeInsets.only(left: 16.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    return Container(
      height: 40.v,
      width: 343.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(
          12.h,
        ),
      ),
      child: TabBar(
        controller: tabviewController,
        labelPadding: EdgeInsets.zero,
        labelColor: appTheme.gray400,
        labelStyle: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'SF Pro Text',
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelColor: theme.colorScheme.onPrimary,
        unselectedLabelStyle: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'SF Pro Text',
          fontWeight: FontWeight.w400,
        ),
        // indicator: BoxDecoration(
        //   // color: theme.colorScheme.onPrimary,
        //   // color: appTheme.orange300.withOpacity(0.75),
        //   borderRadius: BorderRadius.circular(
        //     10.h,
        //     // ),
        //   ),
        // ),
        tabs: [
          Tab(
            child: Text(
              "lbl_am".tr,
              style: TextStyle(color: appTheme.orange300),
            ),
          ),
          Tab(
            child: Text(
              "lbl_pm".tr,
              style: TextStyle(color: appTheme.orange300),
            ),
          ),
        ],
      ),
    );
  }
}

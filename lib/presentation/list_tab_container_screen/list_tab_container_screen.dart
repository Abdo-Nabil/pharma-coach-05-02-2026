import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/general_cubit/general_cubit.dart';
import 'package:mina_s_application5/presentation/list_one_page/list_one_page.dart';
import 'package:mina_s_application5/presentation/list_page/list_page.dart';
import 'package:mina_s_application5/presentation/list_tab_container_screen/cubit/list_tap_container_cubit.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';

import '../questions_screen/cubit/questions_cubit.dart';
import '../questions_screen/last_question/last_question_screen.dart';

late ListTabContainerCubit listCubit;

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

  static Widget builder(
    BuildContext context,
  ) {
    return BlocProvider<ListTabContainerCubit>(
      create: (context) {
        listCubit = ListTabContainerCubit(
          ApiClient(),
          BlocProvider.of<GeneralCubit>(context),
        );
        return listCubit;
      },
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
    tabviewController = TabController(
        length: 2,
        initialIndex:
            BlocProvider.of<GeneralCubit>(context).selectedIndexForListPage,
        vsync: this);
    // BlocProvider.of<ListTabContainerCubit>(context).getAmAndPmVisits();
    BlocProvider.of<ListTabContainerCubit>(context).getAmAndPmLocations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListTabContainerCubit, ListTapContainerState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: BlocConsumer<ListTabContainerCubit, ListTapContainerState>(
              listener: (context, state) {
                // if (state is ListTapContainerLoading) {
                //   ProgressDialogUtils.showProgressDialog();
                // } else if (state is ListTapContainerGetLocationsSuccessState) {
                //   ProgressDialogUtils.hideProgressDialog();
                // }
              },
              builder: (context, state) {
                if (state is ListTapContainerLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                //
                else if (state is ListTapContainerGetLocationsSuccessState) {
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
                                // Center(
                                //   child: Text(
                                //     "Hi from Am",
                                //     style: TextStyle(fontSize: 30),
                                //   ),
                                // ),
                                //
                                BlocProvider.value(
                                  value: listCubit,
                                  child: ListPage(),
                                ),
                                BlocProvider.value(
                                  value: listCubit,
                                  child: ListOnePage(),
                                ),

                                // ListPage.builder(context),
                                // ListOnePage.builder(context),
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

  bool canGoToLastQuestionScreen() {
    final pref = PrefUtils();
    if ((pref.getFirstCategoryAnswer()) != null &&
        !pref.isLastQuestionAnswered(DateTime.now())) {
      return true;
    }
    return false;
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 35.v,
      title: AppbarTitle(
        text: "lbl_locations_list".tr,
        margin: EdgeInsets.only(left: 16.h),
      ),
      actions: [
        Padding(
          padding: EdgeInsetsDirectional.only(end: 10.0.h),
          child: TextButton(
            onPressed: canGoToLastQuestionScreen()
                ? () async {
                    await BlocProvider.of<QuestionsCubit>(context)
                        .getSavedLocallyQuestions("normal");
                    BlocProvider.of<QuestionsCubit>(context)
                        .lastCategoryAnswers = [];
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return LastQuestionScreen();
                      }),
                    );
                  }
                : null,
            child: Text(
              "End of the day",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16.fSize,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        )
      ],
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

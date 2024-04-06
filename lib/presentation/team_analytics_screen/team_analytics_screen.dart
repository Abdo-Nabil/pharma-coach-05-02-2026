import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/presentation/home_page/home_page.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
import 'package:mina_s_application5/widgets/custom_drop_down.dart';
import 'cubit/analysis_cubit.dart';
import 'models/team_analytics_model.dart';
import 'package:mina_s_application5/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/team_analytics_bloc.dart';

class TeamAnalyticsScreen extends StatefulWidget {
  final bool isManualNav;
  TeamAnalyticsScreen({required this.isManualNav, Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context, {bool isManualNav = false}) {
    return BlocProvider<AnalysisCubit>(
      create: (context) => AnalysisCubit(ApiClient()),
      child: TeamAnalyticsScreen(isManualNav: isManualNav),
    );
  }

  @override
  State<TeamAnalyticsScreen> createState() => _TeamAnalyticsScreenState();
}

class _TeamAnalyticsScreenState extends State<TeamAnalyticsScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  int? selectedRepId;
  //
  @override
  void initState() {
    BlocProvider.of<AnalysisCubit>(context).getAnalysis();
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 4.v,
          ),
          child: Column(
            children: [
              CustomElevatedButton(
                height: 40.v,
                text: "lbl_team".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
              ),
              SizedBox(height: 8.v),
              SizedBox(
                width: double.infinity,
                child: DropdownButton<int>(
                  hint: Text("Chose medical rep"),
                  isExpanded: true,
                  value: null,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedRepId = newValue!;
                    });
                  },
                  items: BlocProvider.of<AnalysisCubit>(context, listen: true)
                      .reps
                      .map<DropdownMenuItem<int>>((option) {
                    return DropdownMenuItem<int>(
                      value: option.id,
                      child: Text(option.username),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: BlocBuilder<AnalysisCubit, AnalysisState>(
                    builder: (context, state) {
                  //
                  if (state is AnalysisLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  //
                  else if (state is NoAnalysisState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info,
                            color: appTheme.orange300,
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No Analysis found!",
                            style: TextStyle(fontSize: 20.fSize),
                          ),
                        ],
                      ),
                    );
                  }
                  //
                  else if (state is AnalysisSuccess) {
                    //
                    final temp =
                        BlocProvider.of<AnalysisCubit>(context).analysis;
                    //
                    double repScore = 0;
                    int repCounter = 0;
                    //
                    double teamScore = 0;
                    int teamCounter = 0;
                    //
                    for (int i = 0; i < temp.length; i++) {
                      temp[i].reps.forEach((key, value) {
                        if (key != "$selectedRepId") {
                          teamScore += value;
                          teamCounter++;
                        } else {
                          repScore += value;
                          repCounter++;
                        }
                      });
                    }
                    double avgTeamScore = 0;
                    double avgRepScore = 0;

                    avgTeamScore =
                        teamCounter == 0 ? 0.0 : (teamScore / teamCounter);
                    avgRepScore = repCounter == 0 ? 0.0 : repScore / repCounter;
                    //
                    return Column(
                      children: [
                        SizedBox(height: 8.v),
                        selectedRepId == null
                            ? Container()
                            : Expanded(
                                child: ListView.separated(
                                    itemCount:
                                        BlocProvider.of<AnalysisCubit>(context)
                                            .analysis
                                            .length,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 10.v);
                                    },
                                    itemBuilder: (context, index) {
                                      //
                                      final analysis =
                                          BlocProvider.of<AnalysisCubit>(
                                                  context)
                                              .analysis[index];
                                      //
                                      /* if (!analysis.reps
                                          .containsKey("$selectedRepId")) {
                                        BlocProvider.of<AnalysisCubit>(context)
                                            .emit(NoAnalysisState());
                                      }*/
                                      //
                                      final double repPercentage =
                                          analysis.reps["$selectedRepId"] ==
                                                  null
                                              ? 0.0
                                              : analysis.reps["$selectedRepId"];
                                      //
                                      //
                                      double teamTotal = 0;
                                      double teamAvg = 0;
                                      //
                                      analysis.reps.forEach((key, value) {
                                        teamTotal += value;
                                      });
                                      //
                                      if (analysis.reps.length > 1) {
                                        teamAvg = (teamTotal - repPercentage) /
                                            (analysis.reps.length - 1);
                                      }
                                      //
                                      return BuildTeamAnalysisView(
                                        title: analysis.category,
                                        repPercentage: repPercentage,
                                        teamPercentage: teamAvg,
                                      );
                                    }),
                              ),
                        SizedBox(height: 8.v),
                        selectedRepId == null
                            ? Container()
                            : BuildTeamAnalysisView(
                                title: "Score",
                                repPercentage: avgRepScore,
                                teamPercentage: avgTeamScore,
                              ),
                        SizedBox(height: 12.v),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }),
              ),
              // CustomElevatedButton(
              //   text: "lbl_save_as_svg".tr,
              //   rightIcon: Container(
              //     margin: EdgeInsets.only(left: 4.h),
              //     child: CustomImageView(
              //       imagePath: ImageConstant.imgDownload,
              //       height: 24.adaptSize,
              //       width: 24.adaptSize,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 5.v),
            ],
          ),
        ),
        bottomNavigationBar:
            widget.isManualNav ? _buildBottomBar(context) : null,
      ),
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
      // actions: [
      //   AppbarTrailingIconbuttonOne(
      //     imagePath: ImageConstant.imgGoogleAnalyticsDeepOrange50,
      //     margin: EdgeInsets.only(
      //       left: 16.h,
      //       top: 2.v,
      //       right: 1.h,
      //     ),
      //   ),
      //   AppbarTrailingIconbutton(
      //     imagePath: ImageConstant.imgUsersOnprimary,
      //     margin: EdgeInsets.only(
      //       left: 6.h,
      //       top: 2.v,
      //       right: 17.h,
      //     ),
      //   ),
      // ],
    );
  }

  /// Section Widget
  Widget _buildSCORE(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 13.h,
        vertical: 11.v,
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
            decoration: AppDecoration.fillBlue100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 169.h,
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
          SizedBox(height: 4.v),
          Container(
            decoration: AppDecoration.fillPurple.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.v,
                  width: 205.h,
                  decoration: BoxDecoration(
                    color: appTheme.purple300,
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
                    "lbl_70".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
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

class BuildTeamAnalysisView extends StatelessWidget {
  final String title;
  final double repPercentage;
  final double teamPercentage;
  const BuildTeamAnalysisView({
    required this.title,
    required this.repPercentage,
    required this.teamPercentage,
  });

  @override
  Widget build(BuildContext context) {
    // width: (MediaQuery.of(context).size.width - 60.h) *
    //     (teamPercentage / 100),
    // debugPrint("ssssssssss ${teamPercentage / 100}");
    debugPrint("################ ${teamPercentage}");
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 13.h,
        vertical: 15.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyles.bodySmallStylishSecondaryContainer,
          ),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 60.h,
                decoration: AppDecoration.fillBlue100.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder7,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 16.v,
                      width: (MediaQuery.of(context).size.width - 60.h) *
                          (repPercentage / 100),
                      // MediaQuery.of(context).size.width - 60.h
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(
                          8.h,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     top: 2.v,
                    //     right: 6.h,
                    //   ),
                    //   child: Text(
                    //     "${repPercentage.toStringAsFixed(2)}%",
                    //     style: theme.textTheme.labelLarge,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: Text(
                  "${repPercentage.toStringAsFixed(2)}%",
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.v),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 60.h,
                decoration: AppDecoration.fillPurple.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder7,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 16.v,
                      width: (MediaQuery.of(context).size.width - 60.h) *
                          (teamPercentage / 100),
                      // width: 200,
                      decoration: BoxDecoration(
                        color: appTheme.purple300,
                        borderRadius: BorderRadius.circular(
                          8.h,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     top: 2.v,
                    //     right: 6.h,
                    //   ),
                    //   child: Text(
                    //     "${teamPercentage.toStringAsFixed(2)}%",
                    //     style: theme.textTheme.labelLarge,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                child: Text(
                  "${teamPercentage.toStringAsFixed(2)}%",
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.v),
        ],
      ),
    );
  }
}

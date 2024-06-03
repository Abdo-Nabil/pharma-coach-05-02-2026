import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/home_page/home_page.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/build_rep_analysis_widget.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/cubit/rep_analysis_cubit/rep_analysis_cubit.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/select_medical_rep_alert.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
import 'package:mina_s_application5/widgets/custom_drop_down.dart';
import 'cubit/analysis_cubit/analysis_cubit.dart';
import 'cubit/analysis_cubit/analysis_state.dart';
import 'models/team_analytics_model.dart';
import 'package:mina_s_application5/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/team_analytics_bloc.dart';

enum DateFilter { day, month, year, quarter }

class TeamAnalyticsScreen extends StatefulWidget {
  TeamAnalyticsScreen({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context, {bool isManualNav = false}) {
    return BlocProvider<AnalysisCubit>(
      create: (context) => AnalysisCubit(ApiClient()),
      child: BlocProvider(
        create: (_) => RepAnalysisCubit(ApiClient()),
        child: TeamAnalyticsScreen(),
      ),
    );
  }

  @override
  State<TeamAnalyticsScreen> createState() => _TeamAnalyticsScreenState();
}

class _TeamAnalyticsScreenState extends State<TeamAnalyticsScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  int? selectedRepId;
  bool isTeamToggled = true;
  //
  final pref = PrefUtils();
  late DateTime date;
  late TextEditingController dateController;
  //
  DateFilter dateFilter = DateFilter.day;
  DateTime? pickedDate = DateTime.now();
  //
  late int quarterNumber = GeneralHelper.getQuarter(pickedDate!);
  //

  setDateAndDateControllerBasedOnSelectedRep(int repId) {
    date = pref.getLastVisitDateForThisRep(repId);
    dateController =
        TextEditingController(text: GeneralHelper.formatDateForDisplay1(date));
  }

  setSelectedRepIdBasedOnSelectedDate(DateTime date) {
    final repId = pref.getRepForThisDate(date);
    if (repId == -1) {
      return;
    }
    final temp = BlocProvider.of<AnalysisCubit>(context).reps;
    for (int i = 0; i < temp.length; i++) {
      if (temp[i].id == repId) {
        selectedRepId = repId;
        setState(() {});
        return;
      }
    }
  }

  //
  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  //
  @override
  void initState() {
    setDateAndDateControllerBasedOnSelectedRep(-1);
    BlocProvider.of<AnalysisCubit>(context)
        .getTeamAnalysis(
      pickedDate!,
      dateFilter.name,
    )
        .then((_) {
      setSelectedRepIdBasedOnSelectedDate(DateTime.now());
    });
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
              // SizedBox(height: 16.v),
              Container(
                decoration: AppDecoration.fillPurple.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder17,
                ),
                width: double.infinity,
                child: ClipRRect(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      menuMaxHeight: 300.v,
                      hint: Text("Choose Medical Rep"),
                      isExpanded: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.h, vertical: 2.v),
                      value: selectedRepId,
                      onChanged: (int? newValue) {
                        setDateAndDateControllerBasedOnSelectedRep(newValue!);
                        if (isTeamToggled) {
                          BlocProvider.of<AnalysisCubit>(context)
                              .getTeamAnalysis(
                            date,
                            dateFilter.name,
                          );
                        } else {
                          BlocProvider.of<RepAnalysisCubit>(context)
                              .getRepAnalysis(
                            date,
                            dateFilter.name,
                          );
                        }
                        setState(() {
                          selectedRepId = newValue;
                        });
                        debugPrint("Rep id:: $selectedRepId");
                      },
                      items:
                          BlocProvider.of<AnalysisCubit>(context, listen: true)
                              .reps
                              .map<DropdownMenuItem<int>>((option) {
                        return DropdownMenuItem<int>(
                          value: option.id,
                          child: Text(option.username),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.v),
              Row(
                children: [
                  SizedBox(
                    height: 48.v,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                        ),
                        onTap: () async {
                          final tempDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2080));
                          if (tempDate != null) {
                            //
                            pickedDate = tempDate;
                            dateController.text =
                                GeneralHelper.formatDateForDisplay1(
                                    pickedDate!);
                            //
                            setSelectedRepIdBasedOnSelectedDate(pickedDate!);
                            //
                            if (isTeamToggled) {
                              BlocProvider.of<AnalysisCubit>(context)
                                  .getTeamAnalysis(
                                pickedDate!,
                                dateFilter.name,
                              );
                              quarterNumber =
                                  GeneralHelper.getQuarter(pickedDate!);
                            } else {
                              BlocProvider.of<RepAnalysisCubit>(context)
                                  .getRepAnalysis(
                                pickedDate!,
                                dateFilter.name,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 10.h),
                  Row(
                    children: [
                      Container(
                        height: 48.v,
                        width: MediaQuery.of(context).size.width * 0.17,
                        // padding: EdgeInsets.fromLTRB(16.h, 14.v, 16.h, 14.v),
                        decoration: AppDecoration.fillPurple.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder7 * 2,
                        ),
                        child: Center(
                          child: Text(
                            "Rep",
                            style: CustomTextStyles.labelLargeSFProTextBlack900,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 14.h,
                      ),
                      Container(
                        height: 48.v,
                        width: MediaQuery.of(context).size.width * 0.17,
                        // padding: EdgeInsets.fromLTRB(16.h, 14.v, 16.h, 14.v),
                        decoration: AppDecoration.fillBlue100.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder7 * 2,
                        ),
                        child: Center(
                          child: Text(
                            "Team",
                            style: CustomTextStyles.labelLargeSFProTextBlack900,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 16.h,
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.v),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilterButton(
                        label: 'Day',
                        isSelected: dateFilter.name == DateFilter.day.name,
                        onTap: () {
                          setState(() {
                            dateFilter = DateFilter.day;
                          });
                          if (isTeamToggled) {
                            BlocProvider.of<AnalysisCubit>(context)
                                .getTeamAnalysis(
                              pickedDate!,
                              dateFilter.name,
                            );
                          } else {
                            BlocProvider.of<RepAnalysisCubit>(context)
                                .getRepAnalysis(
                              pickedDate!,
                              dateFilter.name,
                            );
                          }
                        },
                      ),
                      FilterButton(
                        label: 'Month',
                        isSelected: dateFilter.name == DateFilter.month.name,
                        onTap: () {
                          setState(() {
                            dateFilter = DateFilter.month;
                          });
                          if (isTeamToggled) {
                            BlocProvider.of<AnalysisCubit>(context)
                                .getTeamAnalysis(
                              pickedDate!,
                              dateFilter.name,
                            );
                          } else {
                            BlocProvider.of<RepAnalysisCubit>(context)
                                .getRepAnalysis(
                              pickedDate!,
                              dateFilter.name,
                            );
                          }
                        },
                      ),
                      FilterButton(
                        label: 'Quarter',
                        isSelected: dateFilter.name == DateFilter.quarter.name,
                        onTap: () {
                          setState(() {
                            dateFilter = DateFilter.quarter;
                          });
                          if (isTeamToggled) {
                            BlocProvider.of<AnalysisCubit>(context)
                                .getTeamAnalysis(
                              pickedDate!,
                              "q$quarterNumber",
                            );
                          } else {
                            BlocProvider.of<RepAnalysisCubit>(context)
                                .getRepAnalysis(
                              pickedDate!,
                              "q$quarterNumber",
                            );
                          }
                        },
                      ),
                      FilterButton(
                        label: 'YTD',
                        isSelected: dateFilter.name == DateFilter.year.name,
                        onTap: () {
                          setState(() {
                            dateFilter = DateFilter.year;
                          });
                          if (isTeamToggled) {
                            BlocProvider.of<AnalysisCubit>(context)
                                .getTeamAnalysis(
                              pickedDate!,
                              dateFilter.name,
                            );
                          } else {
                            BlocProvider.of<RepAnalysisCubit>(context)
                                .getRepAnalysis(
                              pickedDate!,
                              dateFilter.name,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.v),
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
                  else if (state is TeamAnalysisSuccess) {
                    //
                    final temp =
                        BlocProvider.of<AnalysisCubit>(context).teamAnalysis;
                    if (BlocProvider.of<AnalysisCubit>(context)
                        .teamAnalysis
                        .isEmpty) {
                      BlocProvider.of<AnalysisCubit>(context)
                          .emit(NoAnalysisState());
                    }
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
                            ? Expanded(child: SelectMedicalRepAlert())
                            : Expanded(
                                child: ListView.separated(
                                    itemCount:
                                        BlocProvider.of<AnalysisCubit>(context)
                                            .teamAnalysis
                                            .length,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 10.v);
                                    },
                                    itemBuilder: (context, index) {
                                      //
                                      final analysis =
                                          BlocProvider.of<AnalysisCubit>(
                                                  context)
                                              .teamAnalysis[index];
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
                                            (analysis.reps.length -
                                                (analysis.reps[
                                                            "$selectedRepId"] ==
                                                        null
                                                    ? 0
                                                    : 1));
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
                                title: "Total score",
                                repPercentage: avgRepScore,
                                teamPercentage: avgTeamScore,
                              ),
                        SizedBox(height: 12.v),
                      ],
                    );
                  }
                  //
                  else if (state is RepAnalysisSuccess) {
                    return BuildRepAnalysisWidget(
                      dateFilter: dateFilter,
                      pickedDate: pickedDate!,
                      selectedRepId: selectedRepId,
                    );
                  }
                  //
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
        // bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      // appTheme.blue100
      height: 60.v,
      title: Row(
        children: [
          AppbarTitle(
            text: "lbl_analytics".tr,
            margin: EdgeInsets.only(left: 16.h),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.h),
            child: CustomElevatedButton(
              height: 40.v,
              width: MediaQuery.of(context).size.width * 0.40,
              // text: isTeamToggled ? "lbl_team".tr : "Medical rep",
              text: isTeamToggled ? "Progress" : "Compare to team".tr,
              // buttonStyle: CustomButtonStyles.fillPrimaryTL12,
              buttonStyle: isTeamToggled
                  ? CustomButtonStyles.fillPink
                  : CustomButtonStyles.fillPrimaryTL12,
              buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
              onPressed: () {
                isTeamToggled = !isTeamToggled;
                if (!isTeamToggled) {
                  BlocProvider.of<AnalysisCubit>(context)
                      .emit(RepAnalysisSuccess());

                  BlocProvider.of<RepAnalysisCubit>(context).getRepAnalysis(
                    pickedDate!,
                    dateFilter == DateFilter.quarter
                        ? "q$quarterNumber"
                        : dateFilter.name,
                  );
                } else {
                  BlocProvider.of<AnalysisCubit>(context).getTeamAnalysis(
                    pickedDate!,
                    dateFilter == DateFilter.quarter
                        ? "q$quarterNumber"
                        : dateFilter.name,
                  );
                }
              },
            ),
          ),
        ],
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
    // debugPrint("################ ${teamPercentage}");
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
          SizedBox(height: 6.v),
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
                          (repPercentage / 100),
                      // MediaQuery.of(context).size.width - 60.h
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
                  "${repPercentage.toStringAsFixed(1)}%",
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
                decoration: AppDecoration.fillBlue100.copyWith(
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
                  "${teamPercentage.toStringAsFixed(1)}%",
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.v),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? appTheme.orange300 : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

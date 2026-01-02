import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/home_page/home_page.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/avg_screen.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/build_rep_analysis_widget.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/cubit/avg_screen_cubit/avg_screen_cubit.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/cubit/rep_analysis_cubit/rep_analysis_cubit.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/select_medical_rep_alert.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/custom_bottom_bar.dart';
import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'cubit/analysis_cubit/analysis_cubit.dart';
import 'cubit/analysis_cubit/analysis_state.dart';

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
  DateFilter dateFilter =
      GeneralData.isNSM() ? DateFilter.month : DateFilter.day;
  DateTime? pickedDate = DateTime.now();
  //
  late int quarterNumber = GeneralHelper.getQuarter(pickedDate!);
  //

  setDateAndDateControllerBasedOnSelectedRep(int repId) {
    date = pref.getLastVisitDateForThisRep(repId);
    dateController = TextEditingController(
        text: GeneralData.isNSM()
            ? GeneralHelper.formatDateForDisplay2(date)
            : GeneralHelper.formatDateForDisplay1(date));
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

    ///
    ///  In case of NSM
    if (GeneralData.isNSM()) {
      BlocProvider.of<AnalysisCubit>(context).selectedMonthIndex =
          pickedDate!.month - 1;
      BlocProvider.of<AnalysisCubit>(context).selectedQuarter =
          GeneralHelper.getQuarter(pickedDate!);
    }

    ///
    ///
    //
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
    /// In case of NSM
    late int selectedMonthIndex;
    late int selectedQuarter;
    if (GeneralData.isNSM()) {
      selectedMonthIndex = BlocProvider.of<AnalysisCubit>(context, listen: true)
          .selectedMonthIndex;
      selectedQuarter =
          BlocProvider.of<AnalysisCubit>(context, listen: true).selectedQuarter;
    }

    ///
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
                        quarterNumber = GeneralHelper.getQuarter(pickedDate!);
                        if (isTeamToggled) {
                          BlocProvider.of<AnalysisCubit>(context)
                              .getTeamAnalysis(
                            date,
                            dateFilter.name == DateFilter.quarter.name
                                ? "q$quarterNumber"
                                : dateFilter.name,
                          );
                        } else {
                          BlocProvider.of<RepAnalysisCubit>(context)
                              .getRepAnalysis(
                            date,
                            dateFilter.name == DateFilter.quarter.name
                                ? "q$quarterNumber"
                                : dateFilter.name,
                            isDayFilter: dateFilter.name == DateFilter.day.name,
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
                    height: 40.v,
                    width: MediaQuery.of(context).size.width *
                        (GeneralData.isNSM() ? 0.30 : 0.50),
                    child: Center(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                        ),
                        onTap: () async {
                          DateTime? tempDate;
                          if (GeneralData.isNSM()) {
                            tempDate = await showMonthPicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2100),
                              selectedMonthBackgroundColor:
                                  appTheme.amber700.withOpacity(0.70),
                              selectedMonthTextColor: Colors.white,
                            );
                          } else {
                            tempDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2100),
                            );
                          }

                          if (tempDate != null) {
                            //
                            pickedDate = tempDate;
                            dateController.text = GeneralData.isNSM()
                                ? GeneralHelper.formatDateForDisplay2(
                                    pickedDate!)
                                : GeneralHelper.formatDateForDisplay1(
                                    pickedDate!);
                            //
                            setSelectedRepIdBasedOnSelectedDate(pickedDate!);
                            quarterNumber =
                                GeneralHelper.getQuarter(pickedDate!);
                            //
                            if (GeneralData.isNSM()) {
                              BlocProvider.of<AnalysisCubit>(context)
                                  .selectedQuarter = quarterNumber;
                              BlocProvider.of<AnalysisCubit>(context)
                                  .selectedMonthIndex = pickedDate!.month - 1;
                            }
                            //
                            if (isTeamToggled) {
                              BlocProvider.of<AnalysisCubit>(context)
                                  .getTeamAnalysis(
                                pickedDate!,
                                dateFilter.name == DateFilter.quarter.name
                                    ? "q$quarterNumber"
                                    : dateFilter.name,
                              );
                            } else {
                              BlocProvider.of<RepAnalysisCubit>(context)
                                  .getRepAnalysis(
                                pickedDate!,
                                dateFilter.name == DateFilter.quarter.name
                                    ? "q$quarterNumber"
                                    : dateFilter.name,
                                isDayFilter:
                                    dateFilter.name == DateFilter.day.name,
                              );

                              BlocProvider.of<RepAnalysisCubit>(context)
                                  .selectedMonthIndex = pickedDate!.month - 1;
                              BlocProvider.of<RepAnalysisCubit>(context)
                                      .selectedQuarter =
                                  GeneralHelper.getQuarter(pickedDate!);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40.v,
                            // width: MediaQuery.of(context).size.width * 0.17,
                            padding:
                                EdgeInsets.fromLTRB(16.h, 14.v, 16.h, 14.v),
                            decoration: AppDecoration.fillPurple.copyWith(
                              borderRadius:
                                  BorderRadiusStyle.roundedBorder7 * 2,
                            ),
                            child: Center(
                              child: Text(
                                GeneralData.isNSM() ? "NSM" : "Rep",
                                style: CustomTextStyles
                                    .labelLargeSFProTextBlack900,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 14.h,
                        ),
                        Expanded(
                          child: Container(
                            height: 40.v,
                            // width: MediaQuery.of(context).size.width * 0.17,
                            padding:
                                EdgeInsets.fromLTRB(16.h, 14.v, 16.h, 14.v),
                            decoration: AppDecoration.fillBlue100.copyWith(
                              borderRadius:
                                  BorderRadiusStyle.roundedBorder7 * 2,
                            ),
                            child: Center(
                              child: Text(
                                GeneralData.isNSM() ? "DM" : "Team",
                                style: CustomTextStyles
                                    .labelLargeSFProTextBlack900,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 16.h,
                        // ),
                      ],
                    ),
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
                      ///
                      if (!GeneralData.isNSM())
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
                                isDayFilter:
                                    dateFilter.name == DateFilter.day.name,
                              );
                            }
                          },
                        ),

                      ///
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
                              isDayFilter:
                                  dateFilter.name == DateFilter.day.name,
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
                          quarterNumber = GeneralHelper.getQuarter(pickedDate!);
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
                              isDayFilter:
                                  dateFilter.name == DateFilter.day.name,
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
                              isDayFilter:
                                  dateFilter.name == DateFilter.day.name,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.v),

              ///
              /// In case of NSM
              ///
              if (GeneralData.isNSM())
                Column(
                  children: [
                    Visibility(
                      visible: dateFilter == DateFilter.quarter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(4, (index) {
                          return FilterButton(
                            label: "Q${index + 1}",
                            isSelected: selectedQuarter == index + 1,
                            onTap: () {
                              setState(() {
                                BlocProvider.of<AnalysisCubit>(context)
                                    .selectedQuarter = index + 1;
                              });
                              BlocProvider.of<AnalysisCubit>(context)
                                  .getTeamAnalysis(
                                pickedDate!,
                                'q${index + 1}',
                              );
                            },
                          );
                        }),
                      ),
                    ),
                    Visibility(
                      visible: dateFilter == DateFilter.month,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(monthsList.length, (index) {
                            return FilterButton(
                              label: "${monthsList[index]}",
                              isSelected: selectedMonthIndex == index,
                              onTap: () {
                                setState(() {
                                  BlocProvider.of<AnalysisCubit>(context)
                                      .selectedMonthIndex = index;
                                });
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: dateFilter == DateFilter.quarter ||
                          dateFilter == DateFilter.month,
                      child: SizedBox(height: 16.v),
                    ),
                  ],
                ),

              ///
              ///
              ///
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

                    ///
                    /// In case of UserType == NSM or general user (DM)
                    double repOrNSMScore = 0;
                    int repOrNSMCounter = GeneralData.isNSM() ? temp.length : 0;
                    //
                    double teamOrDMScore = 0;
                    int teamOrDMCounter = GeneralData.isNSM() ? temp.length : 0;
                    //
                    if (GeneralData.isNSM()) {
                      for (int i = 0; i < temp.length; i++) {
                        temp[i].reps.forEach((key, value) {
                          if (key == "${selectedRepId}_NSM") {
                            repOrNSMScore += value;
                          }
                          //
                          else if (key == "${selectedRepId}") {
                            teamOrDMScore += value;
                          }
                          //
                        });
                      }
                    }
                    //
                    else {
                      for (int i = 0; i < temp.length; i++) {
                        temp[i].reps.forEach((key, value) {
                          if (key != "$selectedRepId") {
                            teamOrDMScore += value;
                            teamOrDMCounter++;
                          } else {
                            repOrNSMScore += value;
                            repOrNSMCounter++;
                          }
                        });
                      }
                    }
                    //
                    double avgTeamOrDMScore = 0;
                    double avgRepOrNSMScore = 0;

                    avgTeamOrDMScore = teamOrDMCounter == 0
                        ? 0.0
                        : (teamOrDMScore / teamOrDMCounter);
                    avgRepOrNSMScore = repOrNSMCounter == 0
                        ? 0.0
                        : repOrNSMScore / repOrNSMCounter;
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
                                        BlocProvider.of<AnalysisCubit>(context)
                                            .teamAnalysis[index];

                                    ///
                                    if (GeneralData.isNSM()) {
                                      ///
                                      final double nsm = analysis.reps[
                                                  "${selectedRepId}_NSM"] ==
                                              null
                                          ? 0.0
                                          : analysis
                                              .reps["${selectedRepId}_NSM"];
                                      //
                                      final double dm = analysis
                                                  .reps["${selectedRepId}"] ==
                                              null
                                          ? 0.0
                                          : analysis.reps["${selectedRepId}"];
                                      //

                                      return BuildTeamAnalysisView(
                                        title: analysis.category,
                                        repOrNSMPercentage: nsm,
                                        teamOrDMPercentage: dm,
                                      );

                                      ///
                                    }
                                    //
                                    else {
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
                                      if (analysis.reps.length > 0) {
                                        //
                                        late double valueToSubtract;
                                        if (analysis.reps["$selectedRepId"] !=
                                                null &&
                                            analysis.reps.length == 1) {
                                          valueToSubtract = 0;
                                        } else {
                                          valueToSubtract =
                                              analysis.reps["$selectedRepId"] ==
                                                      null
                                                  ? 0
                                                  : 1;
                                        }

                                        teamAvg = (teamTotal - repPercentage) /
                                            (analysis.reps.length -
                                                valueToSubtract);
                                      }
                                      //
                                      return BuildTeamAnalysisView(
                                        title: analysis.category,
                                        repOrNSMPercentage: repPercentage,
                                        teamOrDMPercentage: teamAvg,
                                      );
                                    }
                                  },
                                ),
                              ),
                        SizedBox(height: 8.v),
                        selectedRepId == null
                            ? Container()
                            : BuildTeamAnalysisView(
                                title: "Total score",
                                repOrNSMPercentage: avgRepOrNSMScore,
                                teamOrDMPercentage: avgTeamOrDMScore,
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
          if (!GeneralData.isNSM())
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.h),
              child: Row(
                children: [
                  CustomElevatedButton(
                    height: 40.v,
                    width: MediaQuery.of(context).size.width * 0.33,
                    text: "Comparison",
                    // buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                    buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                    buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => BlocProvider(
                                    create: (_) => AvgScreenCubit(ApiClient()),
                                    child: AvgScreen(
                                        reps: BlocProvider.of<AnalysisCubit>(
                                      context,
                                    ).reps),
                                  )));
                    },
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  CustomElevatedButton(
                    height: 40.v,
                    width: MediaQuery.of(context).size.width * 0.33,
                    // text: isTeamToggled ? "lbl_team".tr : "Medical rep",
                    text: isTeamToggled
                        ? "Compare to self"
                        : "Compare to team".tr,
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
                        quarterNumber = GeneralHelper.getQuarter(pickedDate!);
                        BlocProvider.of<RepAnalysisCubit>(context)
                            .getRepAnalysis(
                          pickedDate!,
                          dateFilter == DateFilter.quarter
                              ? "q$quarterNumber"
                              : dateFilter.name,
                          isDayFilter: dateFilter.name == DateFilter.day.name,
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
                ],
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

///
/// ******************************************************************
///
class BuildTeamAnalysisView extends StatelessWidget {
  final String title;
  final double repOrNSMPercentage;
  final double teamOrDMPercentage;
  const BuildTeamAnalysisView({
    required this.title,
    required this.repOrNSMPercentage,
    required this.teamOrDMPercentage,
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
                          (repOrNSMPercentage / 100),
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
                  // "${repPercentage.toStringAsFixed(1)}%",
                  "${GeneralHelper.formatDoubleAsRoundedInt(repOrNSMPercentage)}%",
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
                          (teamOrDMPercentage / 100),
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
                  // "${teamPercentage.toStringAsFixed(1)}%",
                  "${GeneralHelper.formatDoubleAsRoundedInt(teamOrDMPercentage)}%",

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

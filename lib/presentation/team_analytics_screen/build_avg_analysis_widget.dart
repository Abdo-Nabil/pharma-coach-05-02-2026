import 'package:flutter/material.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/cubit/avg_screen_cubit/avg_screen_cubit.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/table_text.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/team_analytics_screen.dart';

import '../../core/app_export.dart';
import '../../general_helper.dart';
import 'build_rep_analysis_widget.dart';
import 'category_title_container.dart';
import 'cubit/rep_analysis_cubit/rep_analysis_cubit.dart';
import 'expandable_row_for_month.dart';
import 'expandable_row_for_other.dart';

class BuildAvgAnalysisWidget extends StatefulWidget {
  final DateTime pickedDate;
  final DateFilter dateFilter;
  const BuildAvgAnalysisWidget({
    required this.pickedDate,
    required this.dateFilter,
  });

  @override
  State<BuildAvgAnalysisWidget> createState() => _BuildAvgAnalysisWidgetState();
}

class _BuildAvgAnalysisWidgetState extends State<BuildAvgAnalysisWidget> {
  //
  @override
  void initState() {
    // BlocProvider.of<AvgScreenCubit>(context).selectedMonthIndex =
    //     widget.pickedDate.month - 1;
    // BlocProvider.of<AvgScreenCubit>(context).selectedQuarter =
    //     GeneralHelper.getQuarter(widget.pickedDate);
    // TODO: implement initState
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final selectedMonthIndex =
        BlocProvider.of<AvgScreenCubit>(context, listen: true)
            .selectedMonthIndex;
    // final selectedQuarter =
    //     BlocProvider.of<AvgScreenCubit>(context, listen: true).selectedQuarter;
    //
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.dateFilter != DateFilter.month
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.h),
                        child: Column(
                          children: [
                            Visibility(
                              visible: widget.dateFilter == DateFilter.quarter,
                              child: CategoryTitleContainer(
                                category: "",
                                isHeader: true,
                                hasIcon: false,
                                firstPartWidth:
                                    MediaQuery.of(context).size.width * 0.50,
                                secondChildInRow: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ...BlocProvider.of<AvgScreenCubit>(
                                              context)
                                          .repAnalysis[0]
                                          .reps["avg"]
                                          .entries
                                          .map((e) {
                                        return TableText(
                                            isHeader: true, text: "${e.key}");
                                      }).toList(),
                                    ]),
                              ),
                            ),
                            //
                            ...List.generate(
                              BlocProvider.of<AvgScreenCubit>(context)
                                  .repAnalysis
                                  .length,
                              (index) {
                                final repAnalysis =
                                    BlocProvider.of<AvgScreenCubit>(context)
                                        .repAnalysis[index];
                                //
                                return ExpandableRowForOther(
                                  isQuarter:
                                      widget.dateFilter == DateFilter.quarter,
                                  category: repAnalysis.category,
                                  //
                                  mapEntries:
                                      repAnalysis.reps["avg"].entries.toList(),
                                  //
                                );
                              },
                            ),
                            //
                            //
                            widget.dateFilter != DateFilter.quarter
                                ? CategoryTitleContainer(
                                    category: "Normal calls percentage",
                                    isHeader: true,
                                    hasIcon: false,
                                    firstPartWidth:
                                        MediaQuery.of(context).size.width *
                                            0.700,
                                    secondChildInRow: TableText(
                                        isHeader: true,
                                        text:
                                            "${BlocProvider.of<AvgScreenCubit>(context).repAnalysis[0].normalCallsPercentages["avg"]}%"),
                                  )
                                : CategoryTitleContainer(
                                    category: "Normal calls percentage",
                                    isHeader: true,
                                    hasIcon: false,
                                    firstPartWidth:
                                        MediaQuery.of(context).size.width *
                                            0.50,
                                    secondChildInRow: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ...BlocProvider.of<AvgScreenCubit>(
                                                  context)
                                              .repAnalysis[0]
                                              .normalCallsPercentages["avg"]
                                              .entries
                                              .map((e) {
                                            return TableText(
                                                isHeader: true,
                                                text: "${e.value}%");
                                          }).toList(),
                                        ]),
                                  ),
                            //
                            //
                            widget.dateFilter != DateFilter.quarter
                                ? CategoryTitleContainer(
                                    color: appTheme.totalRowColor,
                                    category: "Total score",
                                    isHeader: true,
                                    hasIcon: false,
                                    firstPartWidth:
                                        MediaQuery.of(context).size.width *
                                            0.700,
                                    secondChildInRow: TableText(
                                        isHeader: true,
                                        text:
                                            "${BlocProvider.of<AvgScreenCubit>(context).repAnalysis[0].averageRepPercentages["avg"]}%"),
                                  )
                                : CategoryTitleContainer(
                                    color: appTheme.totalRowColor,
                                    category: "Total score",
                                    isHeader: true,
                                    hasIcon: false,
                                    firstPartWidth:
                                        MediaQuery.of(context).size.width *
                                            0.50,
                                    secondChildInRow: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ...BlocProvider.of<AvgScreenCubit>(
                                                  context)
                                              .repAnalysis[0]
                                              .averageRepPercentages["avg"]
                                              .entries
                                              .map((e) {
                                            return TableText(
                                                isHeader: true,
                                                text: "${e.value}%");
                                          }).toList(),
                                        ]),
                                  ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.h),
                        child: Column(
                          children: [
                            ...List.generate(
                              BlocProvider.of<AvgScreenCubit>(context)
                                  .repAnalysis
                                  .length,
                              (index) {
                                final repAnalysis =
                                    BlocProvider.of<AvgScreenCubit>(context)
                                        .repAnalysis[index];
                                //
                                return ExpandableRowForMonth(
                                  category: repAnalysis.category,
                                  //
                                  repPercentage:
                                      "${repAnalysis.reps["avg"]["${monthsList[selectedMonthIndex]}"]['rep_percentage']}",
                                  //
                                  //
                                  keys: repAnalysis
                                      .reps["avg"]
                                          ["${monthsList[selectedMonthIndex]}"]
                                          ["Questions"]
                                      .keys
                                      .toList(),
                                  //
                                  values: repAnalysis
                                      .reps["avg"]
                                          ["${monthsList[selectedMonthIndex]}"]
                                          ["Questions"]
                                      .values
                                      .toList(),
                                  //
                                );
                              },
                            ),
                            //
                            CategoryTitleContainer(
                              category: "Normal calls percentage",
                              isHeader: true,
                              hasIcon: false,
                              firstPartWidth:
                                  MediaQuery.of(context).size.width * 0.700,
                              secondChildInRow: TableText(
                                isHeader: true,
                                text:
                                    "${BlocProvider.of<AvgScreenCubit>(context).repAnalysis[0].normalCallsPercentages["avg"]['${monthsList2[selectedMonthIndex]}']}%",
                              ),
                            ),
                            //
                            CategoryTitleContainer(
                              color: appTheme.totalRowColor,
                              category: "Total score",
                              isHeader: true,
                              hasIcon: false,
                              firstPartWidth:
                                  MediaQuery.of(context).size.width * 0.700,
                              secondChildInRow: TableText(
                                isHeader: true,
                                text:
                                    "${BlocProvider.of<AvgScreenCubit>(context).repAnalysis[0].averageRepPercentages["avg"]['${monthsList2[selectedMonthIndex]}']}%",
                              ),
                            ),
                            //
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

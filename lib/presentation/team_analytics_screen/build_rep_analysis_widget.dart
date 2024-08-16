import 'package:flutter/material.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/category_title_container.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/cubit/rep_analysis_cubit/rep_analysis_cubit.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/expandable_row_for_month.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/select_medical_rep_alert.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/table_text.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/team_analytics_screen.dart';

import '../../core/app_export.dart';
import '../../data/apiClient/api_client.dart';
import 'expandable_row_for_other.dart';

class BuildRepAnalysisWidget extends StatefulWidget {
  final DateTime pickedDate;
  final DateFilter dateFilter;
  final int? selectedRepId;

  const BuildRepAnalysisWidget({
    required this.pickedDate,
    required this.dateFilter,
    required this.selectedRepId,
  });

  @override
  State<BuildRepAnalysisWidget> createState() => _BuildRepAnalysisWidgetState();
}

List monthsList = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

List monthsList2 = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

class _BuildRepAnalysisWidgetState extends State<BuildRepAnalysisWidget> {
  //

  //
  @override
  void initState() {
    BlocProvider.of<RepAnalysisCubit>(context).selectedMonthIndex =
        widget.pickedDate.month - 1;
    BlocProvider.of<RepAnalysisCubit>(context).selectedQuarter =
        GeneralHelper.getQuarter(widget.pickedDate);
    // TODO: implement initState
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final selectedMonthIndex =
        BlocProvider.of<RepAnalysisCubit>(context, listen: true)
            .selectedMonthIndex;
    final selectedQuarter =
        BlocProvider.of<RepAnalysisCubit>(context, listen: true)
            .selectedQuarter;
    //
    return Column(
      children: [
        Visibility(
          visible: widget.dateFilter == DateFilter.quarter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) {
              return FilterButton(
                label: "Q${index + 1}",
                isSelected: selectedQuarter == index + 1,
                onTap: () {
                  setState(() {
                    BlocProvider.of<RepAnalysisCubit>(context).selectedQuarter =
                        index + 1;
                  });
                  BlocProvider.of<RepAnalysisCubit>(context).getRepAnalysis(
                    widget.pickedDate,
                    'q${index + 1}',
                  );
                },
              );
            }),
          ),
        ),
        Visibility(
          visible: widget.dateFilter == DateFilter.month,
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
                      BlocProvider.of<RepAnalysisCubit>(context)
                          .selectedMonthIndex = index;
                    });
                  },
                );
              }),
            ),
          ),
        ),
        Visibility(
          visible: widget.dateFilter == DateFilter.quarter ||
              widget.dateFilter == DateFilter.month,
          child: SizedBox(height: 20.v),
        ),
        Expanded(
          child: BlocBuilder<RepAnalysisCubit, RepAnalysisState>(
            builder: (context, state) {
              debugPrint("@@@@@@@@@@@@@ ${widget.selectedRepId}");
              //
              if (state is RepLoading) {
                return Center(child: CircularProgressIndicator());
              }
              //
              else if (state is NoAnalysis) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
              else if (state is RepSuccess) {
                return widget.selectedRepId == null
                    ? SelectMedicalRepAlert()
                    : BlocProvider.of<RepAnalysisCubit>(context)
                            .repAnalysis[0]
                            .reps
                            .containsKey("${widget.selectedRepId}")
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                widget.dateFilter != DateFilter.month
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.h),
                                        child: Column(
                                          children: [
                                            /* widget.dateFilter !=
                                                    DateFilter.quarter
                                                ? CategoryTitleContainer(
                                                    category: "Items",
                                                    isHeader: true,
                                                    hasIcon: false,
                                                    firstPartWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.700,
                                                    secondChildInRow: TableText(
                                                        isHeader: true,
                                                        text:
                                                            "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[0].reps["${widget.selectedRepId}"].keys.first}"),
                                                  )
                                                : CategoryTitleContainer(
                                                    category: "Items",
                                                    isHeader: true,
                                                    hasIcon: false,
                                                    firstPartWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.50,
                                                    secondChildInRow: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ...BlocProvider.of<
                                                                      RepAnalysisCubit>(
                                                                  context)
                                                              .repAnalysis[0]
                                                              .reps[
                                                                  "${widget.selectedRepId}"]
                                                              .entries
                                                              .map((e) {
                                                            return TableText(
                                                                isHeader: true,
                                                                text:
                                                                    "${e.key}");
                                                          }).toList(),
                                                        ]),
                                                  ),*/

                                            //
                                            Visibility(
                                              visible: widget.dateFilter ==
                                                  DateFilter.quarter,
                                              child: CategoryTitleContainer(
                                                category: "",
                                                isHeader: true,
                                                hasIcon: false,
                                                firstPartWidth:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.50,
                                                secondChildInRow: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      ...BlocProvider.of<
                                                                  RepAnalysisCubit>(
                                                              context)
                                                          .repAnalysis[0]
                                                          .reps[
                                                              "${widget.selectedRepId}"]
                                                          .entries
                                                          .map((e) {
                                                        return TableText(
                                                            isHeader: true,
                                                            text: "${e.key}");
                                                      }).toList(),
                                                    ]),
                                              ),
                                            ),
                                            //
                                            Visibility(
                                              visible: widget.dateFilter ==
                                                  DateFilter.day,
                                              child: CategoryTitleContainer(
                                                color: appTheme.totalRowColor,
                                                category: "",
                                                isHeader: true,
                                                hasIcon: false,
                                                firstPartWidth:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.60,
                                                secondChildInRow: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    TableText(
                                                        isHeader: true,
                                                        text: "TD"),
                                                    if (BlocProvider.of<
                                                                RepAnalysisCubit>(
                                                            context)
                                                        .lastVisitRepAnalysisForDayOnly
                                                        .isNotEmpty)
                                                      TableText(
                                                          isHeader: true,
                                                          text: "LV"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //

                                            ...List.generate(
                                              BlocProvider.of<RepAnalysisCubit>(
                                                      context)
                                                  .repAnalysis
                                                  .length,
                                              (index) {
                                                final repAnalysis = BlocProvider
                                                        .of<RepAnalysisCubit>(
                                                            context)
                                                    .repAnalysis[index];
                                                //
                                                return ExpandableRowForOther(
                                                  isDay: widget.dateFilter ==
                                                      DateFilter.day,
                                                  isQuarter:
                                                      widget.dateFilter ==
                                                          DateFilter.quarter,
                                                  category:
                                                      repAnalysis.category,
                                                  //
                                                  mapEntries: repAnalysis
                                                      .reps.entries
                                                      .firstWhere((element) =>
                                                          element.key ==
                                                          "${widget.selectedRepId}")
                                                      .value
                                                      .entries
                                                      .toList(),
                                                  mapEntries2InCaseOfDay: BlocProvider
                                                              .of<RepAnalysisCubit>(
                                                                  context)
                                                          .lastVisitRepAnalysisForDayOnly
                                                          .isEmpty
                                                      ? []
                                                      : BlocProvider
                                                              .of<
                                                                      RepAnalysisCubit>(
                                                                  context)
                                                          .lastVisitRepAnalysisForDayOnly[
                                                              index]
                                                          .reps
                                                          .entries
                                                          .firstWhere((element) =>
                                                              element.key ==
                                                              "${widget.selectedRepId}")
                                                          .value
                                                          .entries
                                                          .toList(),
                                                  //
                                                );
                                              },
                                            ),
                                            //
                                            //
                                            widget.dateFilter !=
                                                    DateFilter.quarter
                                                ? CategoryTitleContainer(
                                                    category:
                                                        "Normal calls percentage",
                                                    isHeader: true,
                                                    hasIcon: false,
                                                    firstPartWidth: widget
                                                                .dateFilter !=
                                                            DateFilter.day
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.700
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.600,
                                                    secondChildInRow: widget
                                                                .dateFilter !=
                                                            DateFilter.day
                                                        ? TableText(
                                                            isHeader: true,
                                                            text:
                                                                "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[0].normalCallsPercentages["${widget.selectedRepId}"]}%")
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              TableText(
                                                                  isHeader:
                                                                      true,
                                                                  text:
                                                                      "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[0].normalCallsPercentages["${widget.selectedRepId}"]}%"),
                                                              if (BlocProvider.of<
                                                                          RepAnalysisCubit>(
                                                                      context)
                                                                  .lastVisitRepAnalysisForDayOnly
                                                                  .isNotEmpty)
                                                                TableText(
                                                                    isHeader:
                                                                        true,
                                                                    text:
                                                                        "${BlocProvider.of<RepAnalysisCubit>(context).lastVisitRepAnalysisForDayOnly[0].normalCallsPercentages["${widget.selectedRepId}"]}%"),
                                                            ],
                                                          ),
                                                  )
                                                : CategoryTitleContainer(
                                                    category:
                                                        "Normal calls percentage",
                                                    isHeader: true,
                                                    hasIcon: false,
                                                    firstPartWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.50,
                                                    secondChildInRow: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ...BlocProvider.of<
                                                                      RepAnalysisCubit>(
                                                                  context)
                                                              .repAnalysis[0]
                                                              .normalCallsPercentages[
                                                                  "${widget.selectedRepId}"]
                                                              .entries
                                                              .map((e) {
                                                            return TableText(
                                                                isHeader: true,
                                                                text:
                                                                    "${e.value}%");
                                                          }).toList(),
                                                        ]),
                                                  ),
                                            //
                                            //
                                            widget.dateFilter !=
                                                    DateFilter.quarter
                                                ? CategoryTitleContainer(
                                                    color:
                                                        appTheme.totalRowColor,
                                                    category: "Total score",
                                                    isHeader: true,
                                                    hasIcon: false,
                                                    firstPartWidth: widget
                                                                .dateFilter !=
                                                            DateFilter.day
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.700
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.600,
                                                    secondChildInRow: widget
                                                                .dateFilter !=
                                                            DateFilter.day
                                                        ? TableText(
                                                            isHeader: true,
                                                            text:
                                                                "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[0].averageRepPercentages["${widget.selectedRepId}"]}%")
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              TableText(
                                                                  isHeader:
                                                                      true,
                                                                  text:
                                                                      "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[0].averageRepPercentages["${widget.selectedRepId}"]}%"),
                                                              if (BlocProvider.of<
                                                                          RepAnalysisCubit>(
                                                                      context)
                                                                  .lastVisitRepAnalysisForDayOnly
                                                                  .isNotEmpty)
                                                                TableText(
                                                                    isHeader:
                                                                        true,
                                                                    text:
                                                                        "${BlocProvider.of<RepAnalysisCubit>(context).lastVisitRepAnalysisForDayOnly[0].averageRepPercentages["${widget.selectedRepId}"]}%"),
                                                            ],
                                                          ),
                                                  )
                                                : CategoryTitleContainer(
                                                    color:
                                                        appTheme.totalRowColor,
                                                    category: "Total score",
                                                    isHeader: true,
                                                    hasIcon: false,
                                                    firstPartWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.50,
                                                    secondChildInRow: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ...BlocProvider.of<
                                                                      RepAnalysisCubit>(
                                                                  context)
                                                              .repAnalysis[0]
                                                              .averageRepPercentages[
                                                                  "${widget.selectedRepId}"]
                                                              .entries
                                                              .map((e) {
                                                            return TableText(
                                                                isHeader: true,
                                                                text:
                                                                    "${e.value}%");
                                                          }).toList(),
                                                        ]),
                                                  ),
                                          ],
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.h),
                                        child: Column(
                                          children: [
                                            /*CategoryTitleContainer(
                                                category: "Items",
                                                isHeader: true,
                                                hasIcon: false,
                                                firstPartWidth:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.700,
                                                secondChildInRow: TableText(
                                                  text: monthsList[
                                                      selectedMonthIndex],
                                                  isHeader: true,
                                                )),*/
                                            ...List.generate(
                                              BlocProvider.of<RepAnalysisCubit>(
                                                      context)
                                                  .repAnalysis
                                                  .length,
                                              (index) {
                                                final repAnalysis = BlocProvider
                                                        .of<RepAnalysisCubit>(
                                                            context)
                                                    .repAnalysis[index];
                                                //
                                                return ExpandableRowForMonth(
                                                  category:
                                                      repAnalysis.category,
                                                  //
                                                  repPercentage:
                                                      "${repAnalysis.reps.entries.firstWhere((element) => element.key == "${widget.selectedRepId}").value["${monthsList[selectedMonthIndex]}"]['rep_percentage']}",
                                                  //
                                                  //
                                                  keys: repAnalysis.reps.entries
                                                      .firstWhere((element) =>
                                                          element.key ==
                                                          "${widget.selectedRepId}")
                                                      .value[
                                                          "${monthsList[selectedMonthIndex]}"]
                                                          ["Questions"]
                                                      .keys
                                                      .toList(),
                                                  //
                                                  values: repAnalysis
                                                      .reps.entries
                                                      .firstWhere((element) =>
                                                          element.key ==
                                                          "${widget.selectedRepId}")
                                                      .value[
                                                          "${monthsList[selectedMonthIndex]}"]
                                                          ["Questions"]
                                                      .values
                                                      .toList(),
                                                  //
                                                );
                                              },
                                            ),
                                            //
                                            CategoryTitleContainer(
                                              category:
                                                  "Normal calls percentage",
                                              isHeader: true,
                                              hasIcon: false,
                                              firstPartWidth:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.700,
                                              secondChildInRow: TableText(
                                                isHeader: true,
                                                text:
                                                    "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[0].normalCallsPercentages["${widget.selectedRepId}"]['${monthsList2[selectedMonthIndex]}']}%",
                                              ),
                                            ),
                                            //
                                            CategoryTitleContainer(
                                              color: appTheme.totalRowColor,
                                              category: "Total score",
                                              isHeader: true,
                                              hasIcon: false,
                                              firstPartWidth:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.700,
                                              secondChildInRow: TableText(
                                                isHeader: true,
                                                text:
                                                    "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[0].averageRepPercentages["${widget.selectedRepId}"]['${monthsList2[selectedMonthIndex]}']}%",
                                              ),
                                            ),
                                            //
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
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

                /////////////////////////////////////
                /* Table(
                  // border: TableBorder.all(
                  //   color: appTheme.orange300,
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                  // defaultColumnWidth: MaxIntrinsicWidth(),
                  columnWidths: const <int, TableColumnWidth>{
                    // 0: IntrinsicColumnWidth(),
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    // 2: FixedColumnWidth(),
                  },
                  defaultVerticalAlignment:
                  TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        TableText(text: "Category", isHeader: true),
                        //
                        ...BlocProvider.of<RepAnalysisCubit>(context)
                            .repAnalysis[0]
                            .reps
                            .entries
                            .first
                            .value
                            .entries
                            .map(
                              (e) {
                            return TableText(text: e.key, isHeader: true);
                          },
                        ).toList(),
                      ],
                    ),
                    ...List.generate(
                      BlocProvider.of<RepAnalysisCubit>(context)
                          .repAnalysis
                          .length,
                          (index) {
                        return TableRow(
                          children: [
                            TableText(
                                text:
                                "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[index].category}"),
                            //
                            ...BlocProvider.of<RepAnalysisCubit>(context)
                                .repAnalysis[index]
                                .reps
                                .entries
                                .first
                                .value
                                .entries
                                .map(
                                  (e) {
                                return TableText(text: '${e.value}%');
                              },
                            ).toList()
                          ],
                        );
                      },
                    ),
                  ],
                )*/
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }
}

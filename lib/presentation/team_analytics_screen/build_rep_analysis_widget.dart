import 'package:flutter/material.dart';
import 'package:mina_s_application5/general_helper.dart';
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

class _BuildRepAnalysisWidgetState extends State<BuildRepAnalysisWidget> {
  //
  late int selectedQuarter = GeneralHelper.getQuarter(widget.pickedDate);
  late int selectedMonthIndex = widget.pickedDate.month;
  final Color totalRowColor = appTheme.orange300.withOpacity(0.50);
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
  //
  @override
  Widget build(BuildContext context) {
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
                    selectedQuarter = index + 1;
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
                      selectedMonthIndex = index;
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
                                    // ? Table(
                                    //     border: TableBorder.all(
                                    //       color: appTheme.orange300,
                                    //       borderRadius:
                                    //           BorderRadius.circular(8),
                                    //     ),
                                    //     // defaultColumnWidth: MaxIntrinsicWidth(),
                                    //     columnWidths: const <int,
                                    //         TableColumnWidth>{
                                    //       // 0: IntrinsicColumnWidth(),
                                    //       0: FlexColumnWidth(3),
                                    //       1: FlexColumnWidth(),
                                    //       2: FlexColumnWidth(),
                                    //       // 2: FixedColumnWidth(),
                                    //     },
                                    //     defaultVerticalAlignment:
                                    //         TableCellVerticalAlignment.middle,
                                    //     children: [
                                    //       /*  TableRow(
                                    //         children: [
                                    //           TableText(
                                    //               text: "Category",
                                    //               isHeader: true),
                                    //           //
                                    //           ...BlocProvider.of<
                                    //                   RepAnalysisCubit>(context)
                                    //               .repAnalysis[0]
                                    //               .reps
                                    //               .entries
                                    //               .first
                                    //               .value
                                    //               .entries
                                    //               .map(
                                    //             (e) {
                                    //               return TableText(
                                    //                   text: e.key,
                                    //                   isHeader: true);
                                    //             },
                                    //           ).toList(),
                                    //         ],
                                    //       ),*/
                                    //       ...List.generate(
                                    //         BlocProvider.of<RepAnalysisCubit>(
                                    //                 context)
                                    //             .repAnalysis
                                    //             .length,
                                    //         (index) {
                                    //           return TableRow(
                                    //             children: [
                                    //               TableText(
                                    //                   text:
                                    //                       "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[index].category}"),
                                    //               //
                                    //               ...BlocProvider.of<
                                    //                           RepAnalysisCubit>(
                                    //                       context)
                                    //                   .repAnalysis[index]
                                    //                   .reps
                                    //                   .entries
                                    //                   .firstWhere((element) =>
                                    //                       element.key ==
                                    //                       "${widget.selectedRepId}")
                                    //                   .value
                                    //                   .entries
                                    //                   .map(
                                    //                 (e) {
                                    //                   return TableText(
                                    //                       text:
                                    //                           '${e.value["rep_percentage"]}%');
                                    //                 },
                                    //               ).toList()
                                    //             ],
                                    //           );
                                    //         },
                                    //       ),
                                    //     ],
                                    //   )
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.h),
                                        child: Column(
                                          children: [
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
                                                // final Map m = {"ss":44};
                                                // debugPrint(
                                                // "kkkkkkkkkkkkk ${repAnalysis.reps.entries.firstWhere((element) => element.key == "${widget.selectedRepId}").value.entries.toList()[0].value['rep_percentage']}");
                                                return ExpandableRowForOther(
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
                                                  //
                                                );
                                              },
                                            ),
                                            Container(
                                              color: totalRowColor,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width *
                                                        (widget.dateFilter ==
                                                                DateFilter
                                                                    .quarter
                                                            ? 0.55
                                                            : 0.70),
                                                    child: TableText(
                                                      text: 'Total score',
                                                    ),
                                                  ),
                                                  // Container(width: 2.v, height: 4.h, color: Colors.grey),

                                                  Container(
                                                    child: widget.dateFilter !=
                                                            DateFilter.quarter
                                                        ? TableText(
                                                            text:
                                                                "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[0].averageRepPercentages["${widget.selectedRepId}"]}%")
                                                        : Expanded(
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  ...BlocProvider.of<RepAnalysisCubit>(
                                                                          context)
                                                                      .repAnalysis[
                                                                          0]
                                                                      .averageRepPercentages[
                                                                          "${widget.selectedRepId}"]
                                                                      .entries
                                                                      .map((e) {
                                                                    return TableText(
                                                                        text:
                                                                            "${e.value}%");
                                                                  }).toList(),
                                                                ]),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.h),
                                        child: Column(
                                          children: [
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
                                            Container(
                                              color: totalRowColor,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.750,
                                                    child: TableText(
                                                      text: 'Total score',
                                                    ),
                                                  ),
                                                  // Container(width: 2.v, height: 4.h, color: Colors.grey),
                                                  Container(
                                                    // width: MediaQuery.of(context).size.width * 0.60,
                                                    child: TableText(
                                                      text:
                                                          "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[0].averageRepPercentages["${widget.selectedRepId}"]['${monthsList[selectedMonthIndex]}']}%",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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

///
/*? SingleChildScrollView(
child: DataTable(
columns: [
DataColumn(
label: TableText(
text: "Category", isHeader: true)),
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
return DataColumn(
label:
TableText(text: e.key, isHeader: true));
},
).toList(),
],
rows: [
DataRow(
cells: [
DataCell(TableText(
text: "Category", isHeader: true)),
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
return DataCell(
TableText(text: e.key, isHeader: true));
},
).toList(),
],
),
...List.generate(
BlocProvider.of<RepAnalysisCubit>(context)
    .repAnalysis
    .length,
(index) {
return DataRow(
cells: [
DataCell(
TableText(
text:
"${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[index].category}"),
),
//
...BlocProvider.of<RepAnalysisCubit>(
context)
    .repAnalysis[index]
    .reps
    .entries
    .first
    .value
    .entries
    .map(
(e) {
return DataCell(
TableText(text: '${e.value}%'));
},
).toList()
],
);
},
),
],
),
)*/
///

/*
Table(
                                        border: TableBorder.all(
                                          color: appTheme.orange300,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        // defaultColumnWidth: MaxIntrinsicWidth(),
                                        columnWidths: const <int,
                                            TableColumnWidth>{
                                          // 0: IntrinsicColumnWidth(),
                                          0: FlexColumnWidth(3),
                                          1: FlexColumnWidth(),
                                          2: FlexColumnWidth(),
                                          // 2: FixedColumnWidth(),
                                        },
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        children: [
                                          /*  TableRow(
                                            children: [
                                              TableText(
                                                  text: "Category",
                                                  isHeader: true),
                                              //
                                              ...BlocProvider.of<
                                                      RepAnalysisCubit>(context)
                                                  .repAnalysis[0]
                                                  .reps
                                                  .entries
                                                  .first
                                                  .value
                                                  .entries
                                                  .map(
                                                (e) {
                                                  return TableText(
                                                      text: e.key,
                                                      isHeader: true);
                                                },
                                              ).toList(),
                                            ],
                                          ),*/
                                          ...List.generate(
                                            BlocProvider.of<RepAnalysisCubit>(
                                                    context)
                                                .repAnalysis
                                                .length,
                                            (index) {
                                              return TableRow(
                                                children: [
                                                  TableText(
                                                      text:
                                                          "${BlocProvider.of<RepAnalysisCubit>(context).repAnalysis[index].category}"),
                                                  //
                                                  ...BlocProvider.of<
                                                              RepAnalysisCubit>(
                                                          context)
                                                      .repAnalysis[index]
                                                      .reps
                                                      .entries
                                                      .firstWhere((element) =>
                                                          element.key ==
                                                          "${widget.selectedRepId}")
                                                      .value
                                                      .entries
                                                      .map(
                                                    (e) {
                                                      return TableText(
                                                          text:
                                                              '${e.value["rep_percentage"]}%');
                                                    },
                                                  ).toList()
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      )
*/

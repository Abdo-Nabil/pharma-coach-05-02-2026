import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/table_text.dart';

import 'category_title_container.dart';

class ExpandableRowForOther extends StatefulWidget {
  final String category;
  final List mapEntries;
  final List mapEntries2InCaseOfDay;
  final bool isQuarter;
  final bool isDay;
  const ExpandableRowForOther({
    required this.category,
    required this.mapEntries,
    this.mapEntries2InCaseOfDay = const [],
    required this.isQuarter,
    this.isDay = false,
  });

  @override
  State<ExpandableRowForOther> createState() => _ExpandableRowForOtherState();
}

class _ExpandableRowForOtherState extends State<ExpandableRowForOther> {
  //
  bool _isExpanded = false;
  //
  @override
  Widget build(BuildContext context) {
    //
    double width =
        MediaQuery.of(context).size.width * (widget.isQuarter ? 0.50 : 0.70);
    width = widget.isDay ? MediaQuery.of(context).size.width * 0.60 : width;
    //
    ///
    ///
    return GestureDetector(
      onTap: () {
        _isExpanded = !_isExpanded;
        setState(() {});
      },
      child: Column(
        children: [
          CategoryTitleContainer(
            category: '${widget.category}',
            firstPartWidth: width,
            secondChildInRow: Row(
              mainAxisAlignment: widget.isQuarter || widget.isDay
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                ...widget.mapEntries.map((e) {
                  return TableText(text: "${e.value['rep_percentage']}%");
                }).toList(),
                if (widget.isDay)
                  ...widget.mapEntries2InCaseOfDay.map((e) {
                    return TableText(text: "${e.value['rep_percentage']}%");
                  }).toList(),
              ],
            ),
          ),
          Visibility(
            visible: _isExpanded,
            child: Container(
              color: Colors.grey.withOpacity(0.05),
              child: Row(
                children: [
                  SizedBox(
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...widget.mapEntries.first.value['Questions'].entries
                              .map(
                            (e) {
                              return TableText(
                                text: e.key,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.isQuarter
                      ? Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ...widget.mapEntries.map((entry) {
                                return Column(
                                  children: [
                                    ...entry.value['Questions'].entries
                                        .map((e) {
                                      return TableText(text: "${e.value}%");
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ...widget.mapEntries.first.value['Questions']
                                      .entries
                                      .map(
                                    (e) {
                                      return TableText(
                                        text: "${e.value}%",
                                      );
                                    },
                                  ),
                                ],
                              ),
                              if (widget.isDay &&
                                  widget.mapEntries2InCaseOfDay.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ...widget.mapEntries2InCaseOfDay.first
                                        .value['Questions'].entries
                                        .map(
                                      (e) {
                                        return TableText(
                                          text: "${e.value}%",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    ///
    ///
    //
    return GestureDetector(
      onTap: () {
        _isExpanded = !_isExpanded;
        setState(() {});
      },
      child: Container(
        // color: widget.color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: width,
                  child: TableText(
                    text: '${widget.category}',
                  ),
                ),
                // Container(width: 2.v, height: 4.h, color: Colors.grey),
                Container(
                  child: Row(
                    children: widget.mapEntries.map((e) {
                      return TableText(text: "${e.value['rep_percentage']}%");
                    }).toList(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  child: Visibility(
                    visible: _isExpanded,
                    child: Column(
                      children: [
                        ...widget.mapEntries.first.value['Questions'].entries
                            .map(
                          (e) {
                            return TableText(
                              text: e.key,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Visibility(
                    visible: _isExpanded,
                    child: Column(
                      children: [
                        ...widget.mapEntries.first.value['Questions'].entries
                            .map(
                          (e) {
                            return TableText(
                              text: "${e.value}%",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/table_text.dart';

import 'category_title_container.dart';

class ExpandableRowForOther extends StatefulWidget {
  final String category;
  final List mapEntries;
  final bool isQuarter;
  const ExpandableRowForOther({
    required this.category,
    required this.mapEntries,
    required this.isQuarter,
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
    final width =
        MediaQuery.of(context).size.width * (widget.isQuarter ? 0.50 : 0.70);
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
              mainAxisAlignment: widget.isQuarter
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: widget.mapEntries.map((e) {
                return TableText(text: "${e.value['rep_percentage']}%");
              }).toList(),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ...widget
                                  .mapEntries.first.value['Questions'].entries
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

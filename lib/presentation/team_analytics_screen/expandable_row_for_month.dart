import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/table_text.dart';

class ExpandableRowForMonth extends StatefulWidget {
  final String category;
  final String repPercentage;
  final List keys;
  final List values;
  const ExpandableRowForMonth({
    required this.category,
    required this.repPercentage,
    required this.keys,
    required this.values,
  });

  @override
  State<ExpandableRowForMonth> createState() => _ExpandableRowForMonthState();
}

class _ExpandableRowForMonthState extends State<ExpandableRowForMonth> {
  //
  bool _isExpanded = false;
  //
  @override
  Widget build(BuildContext context) {
    //
    return GestureDetector(
      onTap: () {
        _isExpanded = !_isExpanded;
        setState(() {});
      },
      child: Column(
        children: [
          Container(
            color: Colors.grey.withOpacity(0.20),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.750,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info,
                          size: 18.h,
                          color: Colors.green,
                        ),
                        Expanded(
                          child: TableText(
                            text: '${widget.category}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Container(width: 2.v, height: 4.h, color: Colors.grey),
                TableText(text: "${widget.repPercentage}%"),
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
                    width: MediaQuery.of(context).size.width * 0.750,
                    child: Visibility(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...widget.keys.map(
                              (e) {
                                return TableText(
                                  text: e,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      ...widget.values.map(
                        (e) {
                          return TableText(
                            text: "$e%",
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

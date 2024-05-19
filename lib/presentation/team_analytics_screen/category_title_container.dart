import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/table_text.dart';

class CategoryTitleContainer extends StatelessWidget {
  final String category;
  final double firstPartWidth;
  final Widget secondChildInRow;
  final bool hasIcon;
  final bool isHeader;
  final Color? color;
  const CategoryTitleContainer({
    required this.category,
    required this.firstPartWidth,
    required this.secondChildInRow,
    this.hasIcon = true,
    this.isHeader = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.grey.withOpacity(0.20),
      child: Row(
        children: [
          SizedBox(
            width: firstPartWidth,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.h),
              child: Row(
                children: [
                  hasIcon
                      ? Icon(
                          Icons.info,
                          size: 18.h,
                          color: Colors.green,
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                    child: TableText(
                      text: category,
                      isHeader: isHeader,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // secondChildInRow,
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: secondChildInRow,
            ),
          ),
        ],
      ),
    );
  }
}

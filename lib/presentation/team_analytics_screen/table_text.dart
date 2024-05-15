import 'package:flutter/material.dart';

class TableText extends StatelessWidget {
  final String text;
  final bool isHeader;
  const TableText({required this.text, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Text(
        text,
        // textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w400,
        ),
      ),
    );
  }
}

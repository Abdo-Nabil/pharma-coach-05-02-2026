import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  final String title;
  final Function onChange;
  const CheckBoxWidget({
    required this.title,
    required this.onChange,
  });

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isChecked,
      onChanged: (value) {
        isChecked = value!;
        setState(() {});
        widget.onChange();
      },
      title: Text(widget.title),
    );
  }
}

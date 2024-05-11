import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

class SelectMedicalRepAlert extends StatelessWidget {
  const SelectMedicalRepAlert();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Please, select a medical rep.',
        style: TextStyle(fontSize: 20.fSize, fontWeight: FontWeight.bold),
      ),
    );
  }
}

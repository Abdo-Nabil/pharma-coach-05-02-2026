import 'package:flutter/cupertino.dart';

final z = [
  {
    "category": "first",
    "reps": {"1": "33.33%", "3": "25.00%", "15": "100.00%"}
  },
  {
    "category": "second",
    "reps": {"1": "100.00%", "3": "75.00%", "15": "50.00%"}
  }
];

class AnalysisModel {
  final String category;
  final Map reps;

  const AnalysisModel({
    required this.category,
    required this.reps,
  });

  factory AnalysisModel.fromMap(Map<String, dynamic> map) {
    Map moddedMap = {};
    for (int i = 0; i < moddedMap.length; i++) {}
    map['reps'].forEach((key, value) {
      // moddedMap['$key'] = double.parse("${value.split('%').first}");
      moddedMap['$key'] = value.toDouble();
    });
    //
    return AnalysisModel(
      category: map['category'] as String,
      reps: moddedMap,
    );
  }
}

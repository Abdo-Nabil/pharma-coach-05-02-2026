import 'dart:developer';

import 'package:flutter/cupertino.dart';

final z = {
  "category": "Personal Attributes",
  "reps": {
    "973": {
      "jan": 50,
      "Feb": 60,
      "March": 40,
    },
    "974": {
      "jan": 50,
      "Feb": 60,
      "March": 40,
    },
  }
};

class RepAnalysisModel {
  final String category;
  final Map<String, dynamic> reps;
  final Map<String, dynamic> averageRepPercentages;
  final Map<String, dynamic> normalCallsPercentages;

  const RepAnalysisModel({
    required this.category,
    required this.reps,
    required this.averageRepPercentages,
    required this.normalCallsPercentages,
  });

  factory RepAnalysisModel.fromMap(
      Map<String, dynamic> map,
      Map<String, dynamic> avgRepPercentage,
      Map<String, dynamic> normalCallsPercentages) {
    return RepAnalysisModel(
      category: map['category'] as String,
      reps: map['reps'],
      averageRepPercentages: avgRepPercentage,
      normalCallsPercentages: normalCallsPercentages,
    );
  }
}

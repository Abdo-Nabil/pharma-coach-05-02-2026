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

  const RepAnalysisModel({
    required this.category,
    required this.reps,
  });

  factory RepAnalysisModel.fromMap(Map<String, dynamic> map) {
    return RepAnalysisModel(
      category: map['category'] as String,
      reps: map['reps'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': this.category,
      'reps': this.reps,
    };
  }
}

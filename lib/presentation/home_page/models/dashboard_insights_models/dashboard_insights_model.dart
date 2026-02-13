import 'dashboard_categories.dart';
import 'dashboard_medical_reps.dart';
import 'dashboard_visits.dart';
import 'dashboard_your_position.dart';

class DashboardInsightsModel {
  final DashboardVisits visits;
  final DashboardMedicalReps medicalReps;
  final DashboardYourPosition yourPosition;
  final DashboardCategories categories;

  DashboardInsightsModel({
    required this.visits,
    required this.medicalReps,
    required this.yourPosition,
    required this.categories,
  });

  factory DashboardInsightsModel.fromMap(Map<String, dynamic> map) {
    return DashboardInsightsModel(
      visits: DashboardVisits.fromMap(map['visits'] ?? {}),
      medicalReps: DashboardMedicalReps.fromMap(map['medical_reps'] ?? {}),
      yourPosition: DashboardYourPosition.fromMap(map['your_position'] ?? {}),
      categories: DashboardCategories.fromMap(map['categories'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'visits': visits.toMap(),
      'medical_reps': medicalReps.toMap(),
      'your_position': yourPosition.toMap(),
      'categories': categories.toMap(),
    };
  }
}

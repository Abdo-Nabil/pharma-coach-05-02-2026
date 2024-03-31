// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

/// This class defines the variables used in the [analytics_page],
/// and is typically used to hold data that is passed between different parts of the application.
class AnalyticsModel extends Equatable {
  AnalyticsModel() {}

  AnalyticsModel copyWith() {
    return AnalyticsModel();
  }

  @override
  List<Object?> get props => [];
}

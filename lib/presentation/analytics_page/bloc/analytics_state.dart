// ignore_for_file: must_be_immutable

part of 'analytics_bloc.dart';

/// Represents the state of Analytics in the application.
class AnalyticsState extends Equatable {
  AnalyticsState({this.analyticsModelObj});

  AnalyticsModel? analyticsModelObj;

  @override
  List<Object?> get props => [
        analyticsModelObj,
      ];

  AnalyticsState copyWith({AnalyticsModel? analyticsModelObj}) {
    return AnalyticsState(
      analyticsModelObj: analyticsModelObj ?? this.analyticsModelObj,
    );
  }
}

// ignore_for_file: must_be_immutable

part of 'analytics_tab_container_bloc.dart';

/// Represents the state of AnalyticsTabContainer in the application.
class AnalyticsTabContainerState extends Equatable {
  AnalyticsTabContainerState({this.analyticsTabContainerModelObj});

  AnalyticsTabContainerModel? analyticsTabContainerModelObj;

  @override
  List<Object?> get props => [
        analyticsTabContainerModelObj,
      ];

  AnalyticsTabContainerState copyWith(
      {AnalyticsTabContainerModel? analyticsTabContainerModelObj}) {
    return AnalyticsTabContainerState(
      analyticsTabContainerModelObj:
          analyticsTabContainerModelObj ?? this.analyticsTabContainerModelObj,
    );
  }
}

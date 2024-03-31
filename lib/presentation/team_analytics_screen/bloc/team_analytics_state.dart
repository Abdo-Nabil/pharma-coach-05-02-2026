// ignore_for_file: must_be_immutable

part of 'team_analytics_bloc.dart';

/// Represents the state of TeamAnalytics in the application.
class TeamAnalyticsState extends Equatable {
  TeamAnalyticsState({
    this.selectedDropDownValue,
    this.teamAnalyticsModelObj,
  });

  SelectionPopupModel? selectedDropDownValue;

  TeamAnalyticsModel? teamAnalyticsModelObj;

  @override
  List<Object?> get props => [
        selectedDropDownValue,
        teamAnalyticsModelObj,
      ];

  TeamAnalyticsState copyWith({
    SelectionPopupModel? selectedDropDownValue,
    TeamAnalyticsModel? teamAnalyticsModelObj,
  }) {
    return TeamAnalyticsState(
      selectedDropDownValue:
          selectedDropDownValue ?? this.selectedDropDownValue,
      teamAnalyticsModelObj:
          teamAnalyticsModelObj ?? this.teamAnalyticsModelObj,
    );
  }
}

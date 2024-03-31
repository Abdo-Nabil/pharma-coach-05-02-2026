import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/models/team_analytics_model.dart';
part 'team_analytics_event.dart';
part 'team_analytics_state.dart';

/// A bloc that manages the state of a TeamAnalytics according to the event that is dispatched to it.
class TeamAnalyticsBloc extends Bloc<TeamAnalyticsEvent, TeamAnalyticsState> {
  TeamAnalyticsBloc(TeamAnalyticsState initialState) : super(initialState) {
    on<TeamAnalyticsInitialEvent>(_onInitialize);
  }

  _onInitialize(
    TeamAnalyticsInitialEvent event,
    Emitter<TeamAnalyticsState> emit,
  ) async {
    emit(state.copyWith(
        teamAnalyticsModelObj: state.teamAnalyticsModelObj?.copyWith(
      dropdownItemList: fillDropdownItemList(),
    )));
  }

  List<SelectionPopupModel> fillDropdownItemList() {
    return [
      SelectionPopupModel(
        id: 1,
        title: "Item One",
        isSelected: true,
      ),
      SelectionPopupModel(
        id: 2,
        title: "Item Two",
      ),
      SelectionPopupModel(
        id: 3,
        title: "Item Three",
      )
    ];
  }
}

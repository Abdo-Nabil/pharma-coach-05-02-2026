import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:mina_s_application5/presentation/analytics_tab_container_screen/models/analytics_tab_container_model.dart';
part 'analytics_tab_container_event.dart';
part 'analytics_tab_container_state.dart';

/// A bloc that manages the state of a AnalyticsTabContainer according to the event that is dispatched to it.
class AnalyticsTabContainerBloc
    extends Bloc<AnalyticsTabContainerEvent, AnalyticsTabContainerState> {
  AnalyticsTabContainerBloc(AnalyticsTabContainerState initialState)
      : super(initialState) {
    on<AnalyticsTabContainerInitialEvent>(_onInitialize);
  }

  _onInitialize(
    AnalyticsTabContainerInitialEvent event,
    Emitter<AnalyticsTabContainerState> emit,
  ) async {}
}

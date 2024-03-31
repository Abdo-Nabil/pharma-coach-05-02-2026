import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:mina_s_application5/presentation/analytics_page/models/analytics_model.dart';
part 'analytics_event.dart';
part 'analytics_state.dart';

/// A bloc that manages the state of a Analytics according to the event that is dispatched to it.
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc(AnalyticsState initialState) : super(initialState) {
    on<AnalyticsInitialEvent>(_onInitialize);
  }

  _onInitialize(
    AnalyticsInitialEvent event,
    Emitter<AnalyticsState> emit,
  ) async {}
}

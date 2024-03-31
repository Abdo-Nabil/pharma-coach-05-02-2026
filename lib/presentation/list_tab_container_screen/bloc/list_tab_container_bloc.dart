import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:mina_s_application5/presentation/list_tab_container_screen/models/list_tab_container_model.dart';
part 'list_tab_container_event.dart';
part 'list_tab_container_state.dart';

/// A bloc that manages the state of a ListTabContainer according to the event that is dispatched to it.
class ListTabContainerBloc
    extends Bloc<ListTabContainerEvent, ListTabContainerState> {
  ListTabContainerBloc(ListTabContainerState initialState)
      : super(initialState) {
    on<ListTabContainerInitialEvent>(_onInitialize);
  }

  _onInitialize(
    ListTabContainerInitialEvent event,
    Emitter<ListTabContainerState> emit,
  ) async {}
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../models/calendarcontainer_item_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/calendar_container_model.dart';
part 'calendar_container_event.dart';
part 'calendar_container_state.dart';

/// A bloc that manages the state of a CalendarContainer according to the event that is dispatched to it.
class CalendarContainerBloc
    extends Bloc<CalendarContainerEvent, CalendarContainerState> {
  CalendarContainerBloc(CalendarContainerState initialState)
      : super(initialState) {
    on<CalendarContainerInitialEvent>(_onInitialize);
  }

  _onInitialize(
    CalendarContainerInitialEvent event,
    Emitter<CalendarContainerState> emit,
  ) async {
    emit(state.copyWith(
        calendarContainerModelObj: state.calendarContainerModelObj?.copyWith(
      calendarcontainerItemList: fillCalendarcontainerItemList(),
    )));
  }

  List<CalendarcontainerItemModel> fillCalendarcontainerItemList() {
    return [
      CalendarcontainerItemModel(
          ahmedEssam: "Ahmed Essam",
          widget: "2",
          sun: "Sun 20-5-2024",
          th: "Th 26-5-2024"),
      CalendarcontainerItemModel(ahmedEssam: "Marwa Ghaleb", widget: "1")
    ];
  }
}

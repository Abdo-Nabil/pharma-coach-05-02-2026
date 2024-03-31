// ignore_for_file: must_be_immutable

part of 'calendar_container_bloc.dart';

/// Represents the state of CalendarContainer in the application.
class CalendarContainerState extends Equatable {
  CalendarContainerState({
    this.selectedDatesFromCalendar1,
    this.calendarContainerModelObj,
  });

  CalendarContainerModel? calendarContainerModelObj;

  List<DateTime?>? selectedDatesFromCalendar1;

  @override
  List<Object?> get props => [
        selectedDatesFromCalendar1,
        calendarContainerModelObj,
      ];

  CalendarContainerState copyWith({
    List<DateTime?>? selectedDatesFromCalendar1,
    CalendarContainerModel? calendarContainerModelObj,
  }) {
    return CalendarContainerState(
      selectedDatesFromCalendar1:
          selectedDatesFromCalendar1 ?? this.selectedDatesFromCalendar1,
      calendarContainerModelObj:
          calendarContainerModelObj ?? this.calendarContainerModelObj,
    );
  }
}

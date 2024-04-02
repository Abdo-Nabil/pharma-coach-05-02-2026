part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
}

class CalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoading extends CalendarState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class CalendarSuccess extends CalendarState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

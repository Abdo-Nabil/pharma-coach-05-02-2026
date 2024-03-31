// ignore_for_file: must_be_immutable

part of 'analytics_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///Analytics widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class AnalyticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the Analytics widget is first created.
class AnalyticsInitialEvent extends AnalyticsEvent {
  @override
  List<Object?> get props => [];
}

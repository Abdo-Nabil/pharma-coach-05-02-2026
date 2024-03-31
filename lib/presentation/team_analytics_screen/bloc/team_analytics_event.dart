// ignore_for_file: must_be_immutable

part of 'team_analytics_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///TeamAnalytics widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class TeamAnalyticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the TeamAnalytics widget is first created.
class TeamAnalyticsInitialEvent extends TeamAnalyticsEvent {
  @override
  List<Object?> get props => [];
}

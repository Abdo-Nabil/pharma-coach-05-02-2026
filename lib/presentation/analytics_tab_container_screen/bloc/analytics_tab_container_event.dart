// ignore_for_file: must_be_immutable

part of 'analytics_tab_container_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///AnalyticsTabContainer widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class AnalyticsTabContainerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the AnalyticsTabContainer widget is first created.
class AnalyticsTabContainerInitialEvent extends AnalyticsTabContainerEvent {
  @override
  List<Object?> get props => [];
}

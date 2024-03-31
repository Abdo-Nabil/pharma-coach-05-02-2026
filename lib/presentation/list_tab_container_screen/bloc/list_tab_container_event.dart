// ignore_for_file: must_be_immutable

part of 'list_tab_container_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///ListTabContainer widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class ListTabContainerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the ListTabContainer widget is first created.
class ListTabContainerInitialEvent extends ListTabContainerEvent {
  @override
  List<Object?> get props => [];
}

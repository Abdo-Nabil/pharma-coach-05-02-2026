// ignore_for_file: must_be_immutable

part of 'list_one_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///ListOne widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class ListOneEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the ListOne widget is first created.
class ListOneInitialEvent extends ListOneEvent {
  @override
  List<Object?> get props => [];
}

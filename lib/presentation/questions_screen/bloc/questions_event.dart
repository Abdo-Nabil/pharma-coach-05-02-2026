// ignore_for_file: must_be_immutable

part of 'questions_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///Questions widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class QuestionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the Questions widget is first created.
class QuestionsInitialEvent extends QuestionsEvent {
  @override
  List<Object?> get props => [];
}

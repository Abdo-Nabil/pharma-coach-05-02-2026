// ignore_for_file: must_be_immutable

part of 'questions_one_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///QuestionsOne widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class QuestionsOneEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the QuestionsOne widget is first created.
class QuestionsOneInitialEvent extends QuestionsOneEvent {
  @override
  List<Object?> get props => [];
}

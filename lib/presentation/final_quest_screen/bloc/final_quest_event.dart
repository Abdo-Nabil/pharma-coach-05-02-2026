// ignore_for_file: must_be_immutable

part of 'final_quest_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///FinalQuest widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class FinalQuestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the FinalQuest widget is first created.
class FinalQuestInitialEvent extends FinalQuestEvent {
  @override
  List<Object?> get props => [];
}

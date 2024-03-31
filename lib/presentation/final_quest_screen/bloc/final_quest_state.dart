// ignore_for_file: must_be_immutable

part of 'final_quest_bloc.dart';

/// Represents the state of FinalQuest in the application.
class FinalQuestState extends Equatable {
  FinalQuestState({
    this.coachingDaysFinalQuestionController,
    this.finalQuestModelObj,
  });

  TextEditingController? coachingDaysFinalQuestionController;

  FinalQuestModel? finalQuestModelObj;

  @override
  List<Object?> get props => [
        coachingDaysFinalQuestionController,
        finalQuestModelObj,
      ];

  FinalQuestState copyWith({
    TextEditingController? coachingDaysFinalQuestionController,
    FinalQuestModel? finalQuestModelObj,
  }) {
    return FinalQuestState(
      coachingDaysFinalQuestionController:
          coachingDaysFinalQuestionController ??
              this.coachingDaysFinalQuestionController,
      finalQuestModelObj: finalQuestModelObj ?? this.finalQuestModelObj,
    );
  }
}

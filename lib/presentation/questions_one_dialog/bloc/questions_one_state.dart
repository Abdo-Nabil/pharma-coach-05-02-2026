// ignore_for_file: must_be_immutable

part of 'questions_one_bloc.dart';

/// Represents the state of QuestionsOne in the application.
class QuestionsOneState extends Equatable {
  QuestionsOneState({this.questionsOneModelObj});

  QuestionsOneModel? questionsOneModelObj;

  @override
  List<Object?> get props => [
        questionsOneModelObj,
      ];

  QuestionsOneState copyWith({QuestionsOneModel? questionsOneModelObj}) {
    return QuestionsOneState(
      questionsOneModelObj: questionsOneModelObj ?? this.questionsOneModelObj,
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/category_model.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/question_answer_model.dart';

import '../../../data/apiClient/api_client.dart';
import '../models/answer_model.dart';

part 'questions_state.dart';

class QuestionsCubit extends Cubit<QuestionsState> {
  final ApiClient apiClient;
  QuestionsCubit(this.apiClient) : super(QuestionsInitial());

  List<CategoryModel> questionsCategories = [];
  //
  int questionNumbers = 0;

  List<QuestionAnswerModel> answers = [];
  //
  bool areAllQuestionsAnswered() {
    return questionNumbers == answers.length;
  }

  //
  _getNumberOfQuestions() {
    questionNumbers = 0;
    for (int i = 0; i < questionsCategories.length; i++) {
      for (int j = 0; j < questionsCategories[i].questions.length; j++) {
        questionNumbers++;
        // answers.add(
        //     QuestionAnswerModel(categoryId: -1, questionId: -1, answer: -1));
      }
    }
  }

  //
  getQuestionCategories(String type) async {
    emit(QuestionsLoading());
    questionsCategories = await apiClient.getQuestionCategories(type);
    _getNumberOfQuestions();
    emit(QuestionsSuccess());
  }

  Future<bool> submitQuestionAnswers() async {
    bool isSend = false;
    //
    final answerModel = AnswerModel(
        visitId: GeneralData.selectedVisitId,
        repId: GeneralData.selectedRepId,
        answers: answers);
    isSend = await apiClient.submitQuestionAnswers(answerModel);
    return isSend;
  }
}

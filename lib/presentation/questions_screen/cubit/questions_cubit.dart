import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/general_helper.dart';
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
  late CategoryModel lastCategory;
  int blockQuestionNumbers = 0;
  int lastQuestionNumbers = 0;

  List<QuestionAnswerModel> lastCategoryAnswers = [];
  List<QuestionAnswerModel> answers = [];
  //
  bool areAllBlockQuestionsAnswered() {
    // return true;
    return blockQuestionNumbers == answers.length;
  }

  //
  _getNumberOfBlockQuestions() {
    blockQuestionNumbers = 0;
    for (int i = 0; i < questionsCategories.length; i++) {
      for (int j = 0; j < questionsCategories[i].questions.length; j++) {
        blockQuestionNumbers++;
        // answers.add(
        //     QuestionAnswerModel(categoryId: -1, questionId: -1, answer: -1));
      }
    }
  }

  _getNumberOfLastCategoryQuestions() {
    lastQuestionNumbers = 0;
    for (int j = 0; j < questionsCategories.last.questions.length; j++) {
      lastQuestionNumbers++;
    }
  }

  bool areAllLastCategoryQuestionsAnswered() {
    return lastQuestionNumbers == lastCategoryAnswers.length;
  }

  //
  getQuestionCategories(String type) async {
    emit(QuestionsLoading());
    questionsCategories = await apiClient.getQuestionCategories(type);
    questionsCategories.removeAt(0);
    _getNumberOfLastCategoryQuestions();
    lastCategory = questionsCategories.removeLast();
    _getNumberOfBlockQuestions();
    emit(QuestionsSuccess());
  }

  Future<bool> submitQuestionAnswers(int visitId) async {
    bool isSend = false;
    //
    final answerModel = AnswerModel(
      visitId: visitId,
      repId: GeneralData.selectedRepId,
      answers: answers,
    );
    isSend = await apiClient.submitQuestionAnswers(answerModel);
    return isSend;
  }

  //
  submitQuestionAnswersLocally(int visitId) async {
    //
    final pref = PrefUtils();
    await pref.saveQuestionsBlockForSingleVisit(visitId, answers);
    await pref.saveSubmittedVisitId(visitId);
  }

  submitEndOfTheDay() async {
    //
    final pref = PrefUtils();
    final firstCategoryQuestions = pref.getFirstCategoryAnswer()!;
    final List<Map<String, dynamic>> lastCategoryQuestions = [];
    //
    for (int i = 0; i < lastCategoryAnswers.length; i++) {
      lastCategoryQuestions.add(lastCategoryAnswers[i].toMap());
    }
    //
    final visits = await apiClient.getVisits(
        "day", GeneralHelper.formatDateForApi(DateTime.now()));
    //
    for (int i = 0; i < visits.length; i++) {
      List<Map<String, dynamic>> allQuestions = [];
      final result = pref.getQuestionsBlockForSingleVisit(visits[i].id);
      if (result == null) {
        continue;
      }

      allQuestions.addAll(result);
      allQuestions.addAll(firstCategoryQuestions);
      allQuestions.addAll(lastCategoryQuestions);
      //

      List<QuestionAnswerModel> answersAsModels = [];
      for (int i = 0; i < allQuestions.length; i++) {
        answersAsModels.add(QuestionAnswerModel.fromMap(allQuestions[i]));
      }
      log("############@@@@@@@@@@ $i :: ${allQuestions}");
      //
      final answerModel = AnswerModel(
        visitId: visits[i].id,
        repId: GeneralData.selectedRepId,
        answers: answersAsModels,
      );
      await apiClient.submitQuestionAnswers(answerModel);
    }
  }
}

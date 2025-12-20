import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/category_model.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/question_answer_model.dart';

import '../../../data/apiClient/api_client.dart';
import '../../../general_cubit/general_cubit.dart';

part 'questions_state.dart';

class QuestionsCubit extends Cubit<QuestionsState> {
  final ApiClient apiClient;
  final GeneralCubit generalCubit;

  QuestionsCubit(this.apiClient, this.generalCubit) : super(QuestionsInitial());

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
/*
  _createVisit(int locationId, String type) async {
    final shift = type == "Hospital" ? "am" : "pm";
    final visitId = await apiClient.createVisit(
      GeneralData.selectedRepId,
      locationId,
      GeneralHelper.formatDateForApi(DateTime.now()),
      shift,
    );
    return visitId;
  }
*/

/*  _getQuestions(String questionType) async {
    questionsCategories = await apiClient.getQuestionCategories(questionType);
    questionsCategories.removeAt(0);
    _getNumberOfLastCategoryQuestions();
    lastCategory = questionsCategories.removeLast();
    _getNumberOfBlockQuestions();
  }*/

  getSavedLocallyQuestions(String questionType) async {
    emit(QuestionsLoading());
    answers = [];
    questionsCategories =
        await generalCubit.getQuestionsCategoriesForToday(questionType);
    questionsCategories.removeAt(0);
    _getNumberOfLastCategoryQuestions();
    lastCategory = questionsCategories.removeLast();
    _getNumberOfBlockQuestions();
    emit(QuestionsSuccess());
  }

  //
/*
  getQuestionCategoriesForAlreadyCreatedVisit(String questionType) async {
    emit(QuestionsLoading());
    await _getQuestions(questionType);
    emit(QuestionsSuccess());
  }
*/
/*

  getQuestionCategoriesAndCreateVisit(
      String questionType, int locationId, String type) async {
    emit(QuestionsLoading());
    final visitId = await _createVisit(locationId, type);
    await _getQuestions(questionType);
    emit(QuestionsSuccess());
    return visitId;
  }
*/

/*  Future<bool> submitQuestionAnswers(int visitId) async {
    bool isSend = false;
    //
    final answerModel = AnswerModel(
      visitId: visitId,
      repId: GeneralData.selectedRepId,
      answers: answers,
    );
    isSend = await apiClient.submitQuestionAnswers(answerModel);
    return isSend;
  }*/

  _createTheVisitLocally(int locationId, String locationType,
      String questionType, String comment) async {
    final shift = locationType == "Hospital" ? "am" : "pm";
    final pref = PrefUtils();

    await pref.addVisitInLocalForToday(
      VisitInfoModel(
        repId: GeneralData.selectedRepId,
        locationId: locationId,
        visitTime: GeneralHelper.formatDateForApi(DateTime.now()),
        accurateVisitTime:
            GeneralHelper.formatAccurateDateForApi(DateTime.now()),
        shift: shift,
        questionType: questionType,
        isQuestionSubmitted: true,
        comment: comment,
      ),
    );
  }

  //
  submitQuestionAnswersLocally(int visitId, locationId, locationType,
      String questionType, String comment) async {
    //
    final pref = PrefUtils();
    await _createTheVisitLocally(
        locationId, locationType, questionType, comment);
    await pref.saveQuestionsBlockForSingleVisit(locationId, answers);
    // await pref.saveSubmittedVisitId(visitId);
  }

  _saveAllQuestionsInLocal() async {
    final pref = PrefUtils();
    //
    final normalCategories = pref.getQuestionsCategories('normal');
    final flashCategories = pref.getQuestionsCategories('flash');
    final normalFirstCategoryQuestions = normalCategories.first.questions;
    final normalLastCategoryQuestions = normalCategories.last.questions;
    final flashFirstCategoryQuestions = flashCategories.first.questions;
    final flashLastCategoryQuestions = flashCategories.last.questions;
    //
    final firstCategoryQuestionsAnswers = pref.getFirstCategoryAnswer()!;
    final List<Map<String, dynamic>> lastCategoryQuestionsAnswers = [];
    //
    for (int i = 0; i < lastCategoryAnswers.length; i++) {
      lastCategoryQuestionsAnswers.add(lastCategoryAnswers[i].toMap());
    }
    //
    final visits = await pref.getVisitsInLocalForToday();
    //
    for (int i = 0; i < visits.length; i++) {
      List<Map<String, dynamic>> allQuestions = [];
      final result = pref.getQuestionsBlockForSingleVisit(visits[i].locationId);

      allQuestions.addAll(result);

      /// We must edit first and last category number && also the entire questions ids to be compatible with normal or flash visits
      /// flash categories  => from 13 to 24
      /// normal categories => from 1 to 12
      /// ///
      /// To make the work dynamic we will use these variables:
      ///     normalFirstCategoryQuestions, normalLastCategoryQuestions,
      ///     flashFirstCategoryQuestions,flashLastCategoryQuestions
      ///
      //
      List<Map<String, dynamic>> newFirstCategoryQuestions = [];
      List<Map<String, dynamic>> newLastCategoryQuestions = [];
      //
      //
      final bool isNormal = visits[i].questionType == 'normal';
      //
      //
      for (int i = 0; i < firstCategoryQuestionsAnswers.length; i++) {
        Map<String, dynamic> newCategory = firstCategoryQuestionsAnswers[i];
        newCategory['category_id'] = isNormal
            ? normalFirstCategoryQuestions[i].categoryId
            : flashFirstCategoryQuestions[i].categoryId;
        newCategory['question_id'] = isNormal
            ? normalFirstCategoryQuestions[i].id
            : flashFirstCategoryQuestions[i].id;
        newFirstCategoryQuestions.add(newCategory);
      }
      //
      for (int i = 0; i < lastCategoryQuestionsAnswers.length; i++) {
        Map<String, dynamic> newCategory = lastCategoryQuestionsAnswers[i];
        newCategory['category_id'] = isNormal
            ? normalLastCategoryQuestions[i].categoryId
            : flashLastCategoryQuestions[i].categoryId;
        newCategory['question_id'] = isNormal
            ? normalLastCategoryQuestions[i].id
            : flashLastCategoryQuestions[i].id;
        newFirstCategoryQuestions.add(newCategory);
      }
      //
      //
      //
      allQuestions.addAll(newFirstCategoryQuestions);
      allQuestions.addAll(newLastCategoryQuestions);
      //
      await pref.saveSingleVisitQuestionsAnswersLocally(
          allQuestions, visits[i].locationId);
    }
  }

  _saveLastVisitDateForThisRep(int repId) async {
    final pref = PrefUtils();
    await pref.saveLastVisitDateForThisRep(repId);
  }

  _markVisitAsGreenInCalendar(int repId) async {
    final pref = PrefUtils();
    await pref.markVisitAsGreenInCalendar(repId);
  }

  submitEndOfTheDay() async {
    //
    final pref = PrefUtils();
    await pref.setLastQuestionAsAnsweredToday();
    await _saveAllQuestionsInLocal();
    await _saveLastVisitDateForThisRep(GeneralData.selectedRepId);
    await _markVisitAsGreenInCalendar(GeneralData.selectedRepId);
    await generalCubit.executeSubmitQuestionsAndRemoveVisitsFromLocal();
  }

/*
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
*/
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/pref_utils.dart';
import '../../../../data/apiClient/api_client.dart';
import '../../../../general_data.dart';
import '../../../../general_helper.dart';
import '../../models/category_model.dart';
import '../../models/question_answer_model.dart';

part 'first_question_state.dart';

class FirstQuestionCubit extends Cubit<FirstQuestionState> {
  final ApiClient apiClient;

  FirstQuestionCubit(this.apiClient) : super(FirstQuestionInitial());

  List<CategoryModel> questionsCategories = [];
  int questionNumbers = 0;
  List<QuestionAnswerModel> answers = [];
  //
  bool areAllQuestionsAnswered() {
    return questionNumbers == answers.length;
  }

  //
  _getNumberOfQuestions() {
    questionNumbers = 0;
    for (int j = 0; j < questionsCategories[0].questions.length; j++) {
      questionNumbers++;
    }
  }

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

  _getQuestions(String questionType) async {
    questionsCategories = await apiClient.getQuestionCategories(questionType);
    _getNumberOfQuestions();
  }

  getQuestionCategoriesForAlreadyCreatedVisit(String questionType) async {
    emit(FirstQuestionsLoading());
    await _getQuestions(questionType);
    emit(FirstQuestionsSuccess());
  }

  getQuestionCategoriesAndCreateVisit(
      String questionType, int locationId, String type) async {
    emit(FirstQuestionsLoading());
    final visitId = await _createVisit(locationId, type);
    await _getQuestions(questionType);
    emit(FirstQuestionsSuccess());
    return visitId;
  }

  submitFirstQuestion() {
    final pref = PrefUtils();
    pref.setFirstCategoryAnswer(answers);
  }
}

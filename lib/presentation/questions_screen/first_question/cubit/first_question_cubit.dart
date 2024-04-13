import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/pref_utils.dart';
import '../../../../data/apiClient/api_client.dart';
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

  getQuestionCategories(String type) async {
    emit(FirstQuestionsLoading());
    questionsCategories = await apiClient.getQuestionCategories(type);
    _getNumberOfQuestions();
    emit(FirstQuestionsSuccess());
  }

  submitFirstQuestion() {
    final pref = PrefUtils();
    pref.setFirstCategoryAnswer(answers);
  }
}

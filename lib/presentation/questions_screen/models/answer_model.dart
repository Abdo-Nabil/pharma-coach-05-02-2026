// {
// "visit_id": 2,
// "rep_id": 1,
// "answers": [
// {
// "category_id": 5,
// "question_id":5,
// "answer":1
// }
// ]
// }

import 'package:mina_s_application5/presentation/questions_screen/models/question_answer_model.dart';

class AnswerModel {
  final int visitId;
  final int repId;
  final List<QuestionAnswerModel> answers;

  const AnswerModel({
    required this.visitId,
    required this.repId,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    List answersAsMaps = [];
    for (int i = 0; i < answers.length; i++) {
      answersAsMaps.add(answers[i].toMap());
    }
    return {
      'visit_id': this.visitId,
      'rep_id': this.repId,
      'answers': answersAsMaps,
    };
  }
}

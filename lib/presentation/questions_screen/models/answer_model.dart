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

import 'package:flutter/cupertino.dart';
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

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    List<QuestionAnswerModel> answersAsModels = [];
    for (int i = 0; i < map['answers'].length; i++) {
      answersAsModels.add(QuestionAnswerModel.fromMap(map['answers'][i]));
    }
    return AnswerModel(
      visitId: map['visit_id'] as int,
      repId: map['rep_id'] as int,
      answers: answersAsModels,
    );
  }
}

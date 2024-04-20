import 'package:mina_s_application5/presentation/questions_screen/models/question_model.dart';

class CategoryModel {
  final int id;
  final String title;
  final String type;
  final List<QuestionModel> questions;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.type,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    List questionsAsMaps = [];

    for (int i = 0; i < questions.length; i++) {
      questionsAsMaps.add(questions[i].toMap());
    }

    return {
      'id': this.id,
      'title': this.title,
      'type': this.type,
      'questions': questionsAsMaps,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    List<QuestionModel> questionsAsModels = [];
    for (int i = 0; i < map['questions'].length; i++) {
      questionsAsModels.add(QuestionModel.fromMap(map['questions'][i]));
    }
    return CategoryModel(
      id: map['id'] as int,
      title: map['title'] as String,
      type: map['type'] as String,
      questions: questionsAsModels,
    );
  }
}

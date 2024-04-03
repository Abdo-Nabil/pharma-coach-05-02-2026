class QuestionAnswerModel {
  final int categoryId;
  final int questionId;
  final int answer;

  const QuestionAnswerModel({
    required this.categoryId,
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': this.categoryId,
      'question_id': this.questionId,
      'answer': this.answer,
    };
  }
}

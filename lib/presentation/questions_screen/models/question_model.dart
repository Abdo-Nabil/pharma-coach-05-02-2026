// {
// "id": 1,
// "category_id": 1,
// "body": "Voluptas odio qui cum quo natus. Sit possimus asperiores iure voluptatem ea deserunt voluptatem."
// },

class QuestionModel {
  final int id;
  final int categoryId;
  final String body;

  const QuestionModel({
    required this.id,
    required this.categoryId,
    required this.body,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      body: map['body'] as String,
    );
  }
}

class DashboardCategories {
  final DashboardCategory? highest;
  final DashboardCategory? lowest;

  DashboardCategories({
    this.highest,
    this.lowest,
  });

  factory DashboardCategories.fromMap(Map<String, dynamic> map) {
    return DashboardCategories(
      highest: map['highest'] != null
          ? DashboardCategory.fromMap(map['highest'])
          : null,
      lowest: map['lowest'] != null
          ? DashboardCategory.fromMap(map['lowest'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'highest': highest?.toMap(),
      'lowest': lowest?.toMap(),
    };
  }
}

class DashboardCategory {
  final String category;
  final double score;

  DashboardCategory({
    required this.category,
    required this.score,
  });

  factory DashboardCategory.fromMap(Map<String, dynamic> map) {
    return DashboardCategory(
      category: map['category'] ?? '',
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'score': score,
    };
  }
}

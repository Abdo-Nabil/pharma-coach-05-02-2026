class DashboardYourPosition {
  final double score;
  final int rank;
  final int totalManagers;
  final double topScore;
  final String companyName;

  DashboardYourPosition({
    required this.score,
    required this.rank,
    required this.totalManagers,
    required this.topScore,
    required this.companyName,
  });

  factory DashboardYourPosition.fromMap(Map<String, dynamic> map) {
    return DashboardYourPosition(
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
      rank: map['rank'] ?? 0,
      totalManagers: map['total_managers'] ?? 0,
      topScore: (map['top_score'] as num?)?.toDouble() ?? 0.0,
      companyName: map['company_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'rank': rank,
      'total_managers': totalManagers,
      'top_score': topScore,
      'company_name': companyName,
    };
  }
}

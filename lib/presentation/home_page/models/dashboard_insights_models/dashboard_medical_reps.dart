class DashboardMedicalReps {
  final DashboardRep? highest;
  final DashboardRep? lowest;

  DashboardMedicalReps({
    this.highest,
    this.lowest,
  });

  factory DashboardMedicalReps.fromMap(Map<String, dynamic> map) {
    return DashboardMedicalReps(
      highest:
          map['highest'] != null ? DashboardRep.fromMap(map['highest']) : null,
      lowest:
          map['lowest'] != null ? DashboardRep.fromMap(map['lowest']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'highest': highest?.toMap(),
      'lowest': lowest?.toMap(),
    };
  }
}

class DashboardRep {
  final int repId;
  final String name;
  final double score;

  DashboardRep({
    required this.repId,
    required this.name,
    required this.score,
  });

  factory DashboardRep.fromMap(Map<String, dynamic> map) {
    return DashboardRep(
      repId: map['rep_id'] ?? 0,
      name: map['name'] ?? '',
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rep_id': repId,
      'name': name,
      'score': score,
    };
  }
}

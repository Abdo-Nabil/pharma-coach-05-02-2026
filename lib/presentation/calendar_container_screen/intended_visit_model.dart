class IntendedVisitModel {
  final String repName;
  final String isoDate;
  final int repId;

  const IntendedVisitModel({
    required this.repName,
    required this.isoDate,
    required this.repId,
  });

  Map<String, dynamic> toMap() {
    return {
      'repName': this.repName,
      'isoDate': this.isoDate,
      'repId': this.repId,
    };
  }

  factory IntendedVisitModel.fromMap(Map<String, dynamic> map) {
    return IntendedVisitModel(
      repName: map['repName'] as String,
      isoDate: map['isoDate'] as String,
      repId: map['repId'] as int,
    );
  }
}

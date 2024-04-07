class IntendedVisitModel {
  final String repName;
  final String stringDate;
  final int repId;

  const IntendedVisitModel({
    required this.repName,
    required this.stringDate,
    required this.repId,
  });

  Map<String, dynamic> toMap() {
    return {
      'repName': this.repName,
      'stringDate': this.stringDate,
      'repId': this.repId,
    };
  }

  factory IntendedVisitModel.fromMap(Map<String, dynamic> map) {
    return IntendedVisitModel(
      repName: map['repName'] as String,
      stringDate: map['stringDate'] as String,
      repId: map['repId'] as int,
    );
  }
}

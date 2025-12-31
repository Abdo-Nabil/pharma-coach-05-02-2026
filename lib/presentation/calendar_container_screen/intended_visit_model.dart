class IntendedVisitModel {
  final String repName;
  final String stringDate;
  final int repId;
  final bool endOfTheDayClicked;
  final int? districtManagerId;

  const IntendedVisitModel({
    required this.repName,
    required this.stringDate,
    required this.repId,
    required this.endOfTheDayClicked,
    this.districtManagerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'repName': this.repName,
      'stringDate': this.stringDate,
      'repId': this.repId,
      'endOfTheDayClicked': this.endOfTheDayClicked,
      'districtManagerId': this.districtManagerId,
    };
  }

  factory IntendedVisitModel.fromMap(Map<String, dynamic> map) {
    return IntendedVisitModel(
      repName: map['repName'] as String,
      stringDate: map['stringDate'] as String,
      repId: map['repId'] as int,
      endOfTheDayClicked: map['endOfTheDayClicked'] == null
          ? false
          : map['endOfTheDayClicked'] as bool,
      districtManagerId: map['districtManagerId'] != null
          ? map['districtManagerId'] as int
          : null,
    );
  }

  copyWith({
    String? repName,
    String? stringDate,
    int? repId,
    bool? endOfTheDayClicked,
    int? districtManagerId,
  }) {
    return IntendedVisitModel(
      repName: repName ?? this.repName,
      stringDate: stringDate ?? this.stringDate,
      repId: repId ?? this.repId,
      endOfTheDayClicked: endOfTheDayClicked ?? this.endOfTheDayClicked,
      districtManagerId: districtManagerId ?? this.districtManagerId,
    );
  }
}

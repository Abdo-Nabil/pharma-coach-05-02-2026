class IntendedVisitModel {
  final String repName;
  final String stringDate;
  final int repId;
  final bool endOfTheDayClicked;

  const IntendedVisitModel({
    required this.repName,
    required this.stringDate,
    required this.repId,
    required this.endOfTheDayClicked,
  });

  Map<String, dynamic> toMap() {
    return {
      'repName': this.repName,
      'stringDate': this.stringDate,
      'repId': this.repId,
      'endOfTheDayClicked': this.endOfTheDayClicked,
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
    );
  }

  copyWith({
    String? repName,
    String? stringDate,
    int? repId,
    bool? endOfTheDayClicked,
  }) {
    return IntendedVisitModel(
      repName: repName ?? this.repName,
      stringDate: stringDate ?? this.stringDate,
      repId: repId ?? this.repId,
      endOfTheDayClicked: endOfTheDayClicked ?? this.endOfTheDayClicked,
    );
  }
}

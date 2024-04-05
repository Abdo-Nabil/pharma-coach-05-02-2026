// {
// "id": 3,
// "name": "El Salam",
// "shift": "PM",
// "rep_id": 1,
// "location_id": 1,
// "manager_id": 6,
// "visit_time": "2024-04-02 05:47:10",
// "location": {
// "id": 1,
// "name": "Rodrick",
// "address": "93477 Rozella Port Apt. 353\nMadelynnfurt, MA 55418-3546",
// "type": "Hospital"
// },
// "rep": {
// "id": 1,
// "first_name": "Juvenal",
// "last_name": "Fadel",
// "email": "amira86@example.net",
// "country": "Myanmar",
// "city": "East Laverne",
// "phone": "(848) 912-2529"
// }
// },

import 'package:mina_s_application5/presentation/calendar_container_screen/models/rep_model.dart';

import 'location_model.dart';

class VisitModel {
  final int id;
  final String shift;
  final String visitTime;
  final LocationModel location;
  final RepModel rep;
  final bool isQuestionSubmitted;

  const VisitModel({
    required this.id,
    required this.shift,
    required this.visitTime,
    required this.location,
    required this.rep,
    required this.isQuestionSubmitted,
  });

  factory VisitModel.fromMap(Map<String, dynamic> map) {
    return VisitModel(
      id: map['id'] as int,
      shift: map['shift'] as String,
      visitTime: map['visit_time'] as String,
      location: LocationModel.fromMap(map['location']),
      rep: RepModel.fromMap(map['rep']),
      isQuestionSubmitted: false,
    );
  }

  VisitModel copyWith({
    int? id,
    String? shift,
    String? visitTime,
    LocationModel? location,
    RepModel? rep,
    bool? isQuestionSubmitted,
  }) {
    return VisitModel(
      id: id ?? this.id,
      shift: shift ?? this.shift,
      visitTime: visitTime ?? this.visitTime,
      location: location ?? this.location,
      rep: rep ?? this.rep,
      isQuestionSubmitted: isQuestionSubmitted ?? this.isQuestionSubmitted,
    );
  }
}

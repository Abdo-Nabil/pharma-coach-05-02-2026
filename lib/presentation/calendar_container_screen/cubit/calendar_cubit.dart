import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/intended_visit_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/rep_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/vsit_model.dart';

import '../../../data/apiClient/api_client.dart';
import '../../../theme/theme_helper.dart';
import '../widgets/calendar_widget.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final ApiClient apiClient;
  CalendarCubit({
    required this.apiClient,
  }) : super(CalendarInitial());

  List<Meeting> meetings = <Meeting>[];

  // getMedicalReps() async {
  //   // await Future.delayed(const Duration(seconds: 3));
  //   // await apiClient.getLocations();
  //   List<RepModel> reps = await apiClient.getMedicalReps();
  // }

  getMedicalReps() async {
    // await Future.delayed(const Duration(seconds: 3));
    // await apiClient.getLocations();
    List<TinyRepModel> reps = await apiClient.getMedicalReps();
  }

  ///this gets all visits but requirements changes to only mark these days as
  /// intended visit for only one rep in a day so the new function is [getMonthlyIntendedVisits]
  /// which get these intended visits from locale
  getMonthlyVisits(String date) async {
    List<VisitModel> visits = await apiClient.getVisits("month", date);
    meetings = <Meeting>[];
    for (int i = 0; i < visits.length; i++) {
      meetings.add(Meeting(
          "${visits[i].rep.firstName}",
          // "${visits[i].rep.firstName} ${visits[i].rep.lastName}",
          GeneralHelper.getDateTimeFromApiVisitTime(visits[i].visitTime),
          GeneralHelper.getDateTimeFromApiVisitTime(visits[i].visitTime),
          // DateTime.now(),
          appTheme.amber700,
          true));
    }

    // final DateTime today = DateTime.now();
    // final DateTime startTime =
    //     DateTime(today.year, today.month, today.day + 1, 9, 0, 0);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // meetings.add(
    //     Meeting('Ahmed Essam', startTime, endTime, appTheme.amber700, true));
    // return meetings;

    emit(CalendarSuccess());
  }

  getMonthlyIntendedVisits() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final sharedPref = PrefUtils();
    List<IntendedVisitModel> intendedVisits =
        await sharedPref.getMonthlyIntendedVisits();
    meetings = <Meeting>[];
    for (int i = 0; i < intendedVisits.length; i++) {
      meetings.add(
        Meeting(
          intendedVisits[i].repName,
          DateTime.parse(intendedVisits[i].isoDate),
          DateTime.parse(intendedVisits[i].isoDate),
          appTheme.amber700,
          true,
        ),
      );
    }

    // final DateTime today = DateTime.now();
    // final DateTime startTime =
    //     DateTime(today.year, today.month, today.day + 1, 9, 0, 0);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // meetings.add(
    //     Meeting('Ahmed Essam', startTime, endTime, appTheme.amber700, true));
    // return meetings;
    emit(CalendarSuccess());
  }

  //
  removeIntendedVisit(DateTime date) async {
    emit(CalendarLoading());
    await Future.delayed(const Duration(seconds: 3));
    String stringDate = (GeneralHelper.getDateOnly(date)).toIso8601String();
    final sharedPref = PrefUtils();
    await sharedPref.removeIntendedVisit(stringDate);
    getMonthlyIntendedVisits();
    emit(CalendarSuccess());
  }
}

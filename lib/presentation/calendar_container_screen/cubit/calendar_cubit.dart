import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/general_helper.dart';
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

  getMedicalReps() async {
    // await Future.delayed(const Duration(seconds: 3));
    // await apiClient.getLocations();
    List<RepModel> reps = await apiClient.getMedicalReps();
  }

  getMonthlyVisits(String date) async {
    List<VisitModel> visits = await apiClient.getVisits("month", date);
    meetings = <Meeting>[];
    for (int i = 0; i < visits.length; i++) {
      meetings.add(Meeting(
          "${visits[i].rep.firstName}${visits[i].rep.lastName}",
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
}

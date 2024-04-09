import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/intended_visit_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/vsit_model.dart';

import '../../../data/apiClient/api_client.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiClient apiClient;
  HomeCubit({required this.apiClient}) : super(HomeInitial());

  List<IntendedVisitModel> intendedVisits = [];

/*
  getTodayVisits() async {
    emit(HomeLoadingState());
    visits = await apiClient.getVisits(
        "day", GeneralHelper.formatDateForApi(DateTime.now()));
    emit(HomeGetVisitsSuccess());
  }

  getThisWeekVisits() async {
    emit(HomeLoadingState());
    visits = [];
    final temp = DateTime.now();
    final dateNow = DateTime(temp.year, temp.month, temp.day);
    final dateAfter8Days = dateNow.add(Duration(days: 8));
    //
    final thisMonth = await apiClient.getVisits(
        "month", GeneralHelper.formatDateForApi(dateNow));
    visits = thisMonth;
    if (dateNow.month != dateAfter8Days.month) {
      final nextMonth = await apiClient.getVisits(
          "month", GeneralHelper.formatDateForApi(dateAfter8Days));
      visits.addAll(nextMonth);
    }
    visits = visits.where((visit) {
      final visitDate = GeneralHelper.formatDateFromApi(visit.visitTime);
      if (visitDate.isAtSameMomentAs(dateNow) ||
          (visitDate.isBefore(dateAfter8Days) && visitDate.isAfter(dateNow))) {
        return true;
      }
      return false;
    }).toList();

    emit(HomeGetVisitsSuccess());
  }
*/

  getThisWeekIntendedVisits() async {
    emit(HomeLoadingState());
    intendedVisits = [];
    final temp = DateTime.now();
    final dateNow = DateTime(temp.year, temp.month, temp.day);
    final dateAfter8Days = dateNow.add(Duration(days: 8));
    //
    final pref = PrefUtils();
    intendedVisits = await pref.getIntendedVisits();
    intendedVisits = intendedVisits.where((visit) {
      final visitDate = GeneralHelper.formatDateFromApi(visit.stringDate);
      if (visitDate.isAtSameMomentAs(dateNow) ||
          (visitDate.isBefore(dateAfter8Days) && visitDate.isAfter(dateNow))) {
        return true;
      }
      return false;
    }).toList();

    intendedVisits.sort((a, b) {
      return GeneralHelper.getDateTimeFromApiVisitTime(a.stringDate)
          .compareTo(GeneralHelper.getDateTimeFromApiVisitTime(b.stringDate));
    });

    emit(HomeGetVisitsSuccess());
  }
}

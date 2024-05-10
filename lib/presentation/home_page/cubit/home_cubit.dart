import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/general_cubit/general_cubit.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/intended_visit_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/vsit_model.dart';

import '../../../data/apiClient/api_client.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiClient apiClient;
  final GeneralCubit generalCubit;
  HomeCubit({
    required this.apiClient,
    required this.generalCubit,
  }) : super(HomeInitial());

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

  _saveQuestionCategoriesInLocal() async {
    await generalCubit.getQuestionsCategoriesForToday("normal");
    await generalCubit.getQuestionsCategoriesForToday("flash");
  }

  _saveLocationsInLocal() async {
    await generalCubit.getLocationsForToday();
  }

  //

  getThisWeekIntendedVisits() async {
    emit(HomeLoadingState());
    await _saveQuestionCategoriesInLocal();
    await _saveLocationsInLocal();
    await generalCubit.executeSubmitQuestionsAndRemoveVisitsFromLocal();
    //
    final pref = PrefUtils();
    intendedVisits = await pref.getThisWeekIntendedVisits();
    emit(HomeGetVisitsSuccess());
  }
}

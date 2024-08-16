import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/general_data.dart';

import '../../../../data/apiClient/api_client.dart';
import '../../../../general_helper.dart';
import '../../models/rep_analysis_model.dart';
import '../../team_analytics_screen.dart';

part 'rep_analysis_state.dart';

class RepAnalysisCubit extends Cubit<RepAnalysisState> {
  final ApiClient apiClient;

  RepAnalysisCubit(this.apiClient) : super(RepAnalysisInitial());

  List<RepAnalysisModel> repAnalysis = [];
  List<RepAnalysisModel> lastVisitRepAnalysisForDayOnly = [];
  late int selectedQuarter;
  late int selectedMonthIndex;
  DateFilter dateFilter = DateFilter.year;
  //
  getRepAnalysis(DateTime date, String dateScope,
      {bool isDayFilter = false}) async {
    //
    emit(RepLoading());

    //
    // await Future.delayed(const Duration(seconds: 3));
    //
    if (isDayFilter) {
      final pref = PrefUtils();
      final date2 =
          await pref.getBeforeLastVisitDate(GeneralData.selectedRepId);
      if (date2 != null) {
        lastVisitRepAnalysisForDayOnly =
            await apiClient.getRepAnalysis(date2, dateScope);
      }
    }

    //
    String dateAsString = GeneralHelper.formatDateForApi(date);
    repAnalysis = await apiClient.getRepAnalysis(dateAsString, dateScope);
    //
    if (repAnalysis.isEmpty) {
      emit(NoAnalysis());
      return;
    }
    // reps = await apiClient.getMedicalReps();
    emit(RepSuccess());
  }
}

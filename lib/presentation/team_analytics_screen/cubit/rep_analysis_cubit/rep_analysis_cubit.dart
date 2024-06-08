import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../data/apiClient/api_client.dart';
import '../../../../general_helper.dart';
import '../../models/rep_analysis_model.dart';
import '../../team_analytics_screen.dart';

part 'rep_analysis_state.dart';

class RepAnalysisCubit extends Cubit<RepAnalysisState> {
  final ApiClient apiClient;

  RepAnalysisCubit(this.apiClient) : super(RepAnalysisInitial());

  List<RepAnalysisModel> repAnalysis = [];
  late int selectedQuarter;
  late int selectedMonthIndex;
  DateFilter dateFilter = DateFilter.year;
  //
  getRepAnalysis(
    DateTime date,
    String dateScope,
  ) async {
    String dateAsString = GeneralHelper.formatDateForApi(date);
    //
    emit(RepLoading());

    //
    // await Future.delayed(const Duration(seconds: 3));
    repAnalysis = await apiClient.getRepAnalysis(dateAsString, dateScope);
    if (repAnalysis.isEmpty) {
      emit(NoAnalysis());
      return;
    }
    // reps = await apiClient.getMedicalReps();
    emit(RepSuccess());
  }
}

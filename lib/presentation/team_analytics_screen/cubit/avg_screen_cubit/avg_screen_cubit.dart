import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../data/apiClient/api_client.dart';
import '../../../../general_helper.dart';
import '../../models/rep_analysis_model.dart';

part 'avg_screen_state.dart';

class AvgScreenCubit extends Cubit<AvgScreenState> {
  final ApiClient apiClient;
  AvgScreenCubit(this.apiClient) : super(AvgScreenInitial());
  //
  List<int> selectedRepsIds = [];
  //
  List<RepAnalysisModel> repAnalysis = [];
  late int selectedQuarter;
  late int selectedMonthIndex;
  //
  getAvgRepAnalysis(
    DateTime date,
    String dateScope,
  ) async {
    String dateAsString = GeneralHelper.formatDateForApi(date);
    //
    emit(AvgLoading());
    //
    repAnalysis = await apiClient.getAvgRepAnalysis(
        dateAsString, dateScope, selectedRepsIds);
    if (repAnalysis.isEmpty) {
      emit(AvgNoAnalysis());
      return;
    }
    // reps = await apiClient.getMedicalReps();
    emit(AvgSuccess());
  }

  addOrRemoveMedicalRep(int repId) {
    if (selectedRepsIds.contains(repId)) {
      selectedRepsIds.remove(repId);
    } else {
      selectedRepsIds.add(repId);
    }
  }
}

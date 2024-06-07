import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/apiClient/api_client.dart';
import '../../../../general_helper.dart';
import '../../models/rep_analysis_model.dart';

part 'avg_screen_state.dart';

class AvgScreenCubit extends Cubit<AvgScreenState> {
  final ApiClient apiClient;
  AvgScreenCubit(this.apiClient) : super(AvgScreenInitial());

  List<RepAnalysisModel> repAnalysis = [];

  getRepAnalysis(
    DateTime date,
    String dateScope,
  ) async {
    String dateAsString = GeneralHelper.formatDateForApi(date);
    //
    emit(AvgLoading());
    //
    await Future.delayed(const Duration(seconds: 3));
    repAnalysis = await apiClient.getRepAnalysis(dateAsString, dateScope);
    if (repAnalysis.isEmpty) {
      emit(AvgNoAnalysis());
      return;
    }
    // reps = await apiClient.getMedicalReps();
    emit(AvgSuccess());
  }
}

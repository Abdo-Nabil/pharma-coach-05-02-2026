import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/rep_model.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/models/analysis_model.dart';

import '../../../data/apiClient/api_client.dart';

part 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final ApiClient apiClient;
  AnalysisCubit(this.apiClient) : super(AnalysisInitial());

  List<AnalysisModel> analysis = [];
  List<TinyRepModel> reps = [];
  //
  getAnalysis(DateTime date, String dateScope) async {
    String dateAsString = GeneralHelper.formatDateForApi(date);
    emit(AnalysisLoading());
    analysis = await apiClient.getAnalysis(dateAsString, dateScope);
    reps = await apiClient.getMedicalReps();
    emit(AnalysisSuccess());
  }
}

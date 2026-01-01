import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/rep_model.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/models/rep_analysis_model.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/models/team_analysis_model.dart';

import '../../../../data/apiClient/api_client.dart';
import '../../../../safe_cubit.dart';
import 'analysis_state.dart';

class AnalysisCubit extends SafeCubit<AnalysisState> {
  final ApiClient apiClient;
  AnalysisCubit(this.apiClient) : super(AnalysisInitial());

  List<TeamAnalysisModel> teamAnalysis = [];
  List<RepAnalysisModel> repAnalysis = [];
  List<TinyRepModel> reps = [];
  //
  getTeamAnalysis(DateTime date, String dateScope) async {
    String dateAsString = GeneralHelper.formatDateForApi(date);
    emit(AnalysisLoading());
    teamAnalysis = await apiClient.getTeamAnalysis(dateAsString, dateScope);
    reps = await apiClient.getMedicalReps(null);
    emit(TeamAnalysisSuccess());
  }
/*
  getRepAnalysis(
    DateTime date,
    String dateScope,
  ) async {
    String dateAsString = GeneralHelper.formatDateForApi(date);
    //
    emit(AnalysisLoading());
    // await Future.delayed(const Duration(seconds: 3));
    repAnalysis = await apiClient.getRepAnalysis(dateAsString, dateScope);
    // reps = await apiClient.getMedicalReps();
    emit(RepAnalysisSuccess());
  }*/
}

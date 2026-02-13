import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/presentation/home_page/cubit/dashboard_insights_state.dart';

class DashboardInsightsCubit extends Cubit<DashboardInsightsState> {
  final ApiClient apiClient;

  DashboardInsightsCubit({required this.apiClient})
      : super(const DashboardInsightsState());

  Future<void> getDashboardInsights({required bool isRefresh}) async {
    if (state.insights != null && !isRefresh) {
      emit(state.copyWith(status: DashboardInsightsStatus.success));
      return;
    }

    if (state.insights == null && isRefresh) {
      emit(state.copyWith(status: DashboardInsightsStatus.loading));
    }
    try {
      final insights = await apiClient.getDashboardInsights();
      emit(state.copyWith(
        status: DashboardInsightsStatus.success,
        insights: insights,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardInsightsStatus.error,
        errorMessage: 'Something Went Wrong!',
      ));
    }
  }
}

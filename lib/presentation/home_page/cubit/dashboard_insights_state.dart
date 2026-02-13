import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/presentation/home_page/models/dashboard_insights_models/dashboard_insights_model.dart';

enum DashboardInsightsStatus { initial, loading, success, error }

class DashboardInsightsState extends Equatable {
  final DashboardInsightsStatus status;
  final DashboardInsightsModel? insights;
  final String? errorMessage;

  const DashboardInsightsState({
    this.status = DashboardInsightsStatus.initial,
    this.insights,
    this.errorMessage,
  });

  DashboardInsightsState copyWith({
    DashboardInsightsStatus? status,
    DashboardInsightsModel? insights,
    String? errorMessage,
  }) {
    return DashboardInsightsState(
      status: status ?? this.status,
      insights: insights ?? this.insights,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, insights, errorMessage];
}

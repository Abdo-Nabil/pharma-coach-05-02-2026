part of 'rep_analysis_cubit.dart';

abstract class RepAnalysisState extends Equatable {
  const RepAnalysisState();
}

class RepAnalysisInitial extends RepAnalysisState {
  @override
  List<Object> get props => [];
}

class RepLoading extends RepAnalysisState {
  @override
  List<Object> get props => [];
}

class RepSuccess extends RepAnalysisState {
  @override
  List<Object> get props => [];
}

class NoAnalysis extends RepAnalysisState {
  @override
  List<Object> get props => [];
}

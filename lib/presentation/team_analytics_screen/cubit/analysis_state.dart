part of 'analysis_cubit.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();
}

class AnalysisInitial extends AnalysisState {
  @override
  List<Object> get props => [];
}

class AnalysisLoading extends AnalysisState {
  @override
  List<Object> get props => [];
}

class AnalysisSuccess extends AnalysisState {
  @override
  List<Object> get props => [];
}

class NoAnalysisState extends AnalysisState {
  @override
  List<Object> get props => [];
}

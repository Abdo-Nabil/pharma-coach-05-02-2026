import 'package:equatable/equatable.dart';

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

class TeamAnalysisSuccess extends AnalysisState {
  @override
  List<Object> get props => [];
}

class RepAnalysisSuccess extends AnalysisState {
  @override
  List<Object> get props => [];
}

class NoAnalysisState extends AnalysisState {
  @override
  List<Object> get props => [];
}

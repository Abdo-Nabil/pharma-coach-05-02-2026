// ignore_for_file: must_be_immutable

part of 'add_medical_rep_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///AddMedicalRep widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class AddMedicalRepEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the AddMedicalRep widget is first created.
class AddMedicalRepInitialEvent extends AddMedicalRepEvent {
  @override
  List<Object?> get props => [];
}

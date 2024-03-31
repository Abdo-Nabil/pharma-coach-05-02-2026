import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:mina_s_application5/presentation/add_medical_rep_dialog/models/add_medical_rep_model.dart';
part 'add_medical_rep_event.dart';
part 'add_medical_rep_state.dart';

/// A bloc that manages the state of a AddMedicalRep according to the event that is dispatched to it.
class AddMedicalRepBloc extends Bloc<AddMedicalRepEvent, AddMedicalRepState> {
  AddMedicalRepBloc(AddMedicalRepState initialState) : super(initialState) {
    on<AddMedicalRepInitialEvent>(_onInitialize);
  }

  _onInitialize(
    AddMedicalRepInitialEvent event,
    Emitter<AddMedicalRepState> emit,
  ) async {
    emit(state.copyWith(
      searchController: TextEditingController(),
    ));
  }
}

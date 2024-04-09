import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/location_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/rep_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/apiClient/api_client.dart';
import '../../../general_data.dart';
import '../../calendar_container_screen/cubit/calendar_cubit.dart';
import '../../calendar_container_screen/intended_visit_model.dart';

part 'add_medical_rep_state.dart';

class AddMedicalRepCubit extends Cubit<AddMedicalRepState> {
  final ApiClient apiClient;
  final CalendarCubit calendarCubit;
  AddMedicalRepCubit({required this.apiClient, required this.calendarCubit})
      : super(AddMedicalRepInitial());

  // List<RepModel> reps = [];
  List<TinyRepModel> reps = [];
  List<LocationModel> locations = [];
  //
  // late int selectedRepId;
  // late int selectedLocationId;
  // String shift = 'am';

  //

  getMedicalReps() async {
    emit(AddMedicalRepLoading());
    reps = await apiClient.getMedicalReps();
    emit(GetRepsSuccessState());
  }

  // getRepLocations(int repId) async {
  //   emit(AddMedicalRepLoading());
  //   selectedRepId = repId;
  //   locations = await apiClient.getRepLocations(repId);
  //   emit(GetLocationsSuccessState());
  // }
  //
  // setLocationIdAndShowSubmit(int locationId) {
  //   selectedLocationId = locationId;
  //   emit(ShowSubmitState());
  // }

  // createVisit() async {
  //   emit(AddMedicalRepLoading());
  //   final visitTime = GeneralHelper.formatDateForApi(GeneralData.selectedDate);
  //   await apiClient.createVisit(
  //       selectedRepId, selectedLocationId, visitTime, shift);
  //   await calendarCubit
  //       .getMonthlyVisits(GeneralHelper.formatDateForApi(DateTime.now()));
  //   emit(FinishSubmitState());
  // }

  addIntendedVisit(IntendedVisitModel intendedVisitModel) async {
    emit(AddMedicalRepLoading());
    final sharedPref = PrefUtils();
    await sharedPref.addNewIntendedVisit(intendedVisitModel);
    // await calendarCubit.getMonthlyIntendedVisits();
    await calendarCubit.getData();
    emit(FinishSubmitState());
  }
}

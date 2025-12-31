import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/location_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/rep_model.dart';

import '../../../data/apiClient/api_client.dart';
import '../../../general_data.dart';
import '../../calendar_container_screen/cubit/calendar_cubit.dart';
import '../../calendar_container_screen/intended_visit_model.dart';
import '../../calendar_container_screen/models/district_manager_model.dart';

part 'add_medical_rep_state.dart';

class AddMedicalRepCubit extends Cubit<AddMedicalRepState> {
  final ApiClient apiClient;
  final CalendarCubit calendarCubit;
  AddMedicalRepCubit({required this.apiClient, required this.calendarCubit})
      : super(AddMedicalRepInitial());

  // List<RepModel> reps = [];
  List<TinyRepModel> reps = [];
  List<LocationModel> locations = [];
  List<DistrictManagerModel> districtManagers = [];
  //
  // late int selectedRepId;
  // late int selectedLocationId;
  // String shift = 'am';

  //

  getMedicalReps() async {
    emit(AddMedicalRepLoading());
    reps = await apiClient.getMedicalReps(GeneralData.selectedDistrictManager);
    emit(GetRepsSuccessState());
  }

  getDistrictManagers() async {
    emit(AddMedicalRepLoading());
    districtManagers = await apiClient.getDistrictManagersUnderNSM();
    emit(GetDistrictManagersSuccessState());
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
    GeneralData.selectedDistrictManager = null;
    await calendarCubit.getData();
    emit(FinishSubmitState());
  }
}

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/location_model.dart';

import '../../../data/apiClient/api_client.dart';
import '../../calendar_container_screen/models/vsit_model.dart';

part 'list_tap_container_state.dart';

class ListTabContainerCubit extends Cubit<ListTapContainerState> {
  final ApiClient apiClient;

  ListTabContainerCubit(this.apiClient) : super(ListTapContainerInitial());

/*
  List<VisitModel> amVisits = [];
  List<VisitModel> pmVisits = [];

  getAmAndPmVisits() async {
    emit(ListTapContainerLoading());
    final visits = await apiClient.getVisits(
        'day', GeneralHelper.formatDateForApi(DateTime.now()));
    for (int i = 0; i < visits.length; i++) {
      if (visits[i].shift == "AM") {
        amVisits.add(visits[i]);
      } else if (visits[i].shift == "PM") {
        pmVisits.add(visits[i]);
      }
    }
    emit(ListTapContainerGetVisitSuccessState());
  }
  */

  int? repId;
  //
  List<int> createdVisitsLocationIds = [];
  List<VisitModel> visits = [];
  List<LocationModel> amLocations = [];
  List<LocationModel> pmLocations = [];
  //
  Future<int?> getRepIdForIntendedVisitToday() async {
    final sharedPref = PrefUtils();
    final list = sharedPref.getMonthlyIntendedVisits();
    for (int i = 0; i < list.length; i++) {
      if (list[i].stringDate ==
          GeneralHelper.formatDateForApi(DateTime.now())) {
        repId = list[i].repId;
        GeneralData.selectedRepId = repId!;
        return repId;
      }
    }
    return null;
  }

  getAmAndPmLocations() async {
    emit(ListTapContainerLoading());
    final repId = await getRepIdForIntendedVisitToday();
    if (repId == null) {
      emit(ListTapContainerGetLocationsSuccessState(
          pmLocations: [], amLocations: []));
      return;
    }
    //

    final locations = await apiClient.getRepLocations(repId);

    amLocations = [];
    pmLocations = [];
    for (int i = 0; i < locations.length; i++) {
      if (locations[i].type == "Hospital") {
        amLocations.add(locations[i]);
      } else if (locations[i].type == "Clinic") {
        pmLocations.add(locations[i]);
      }
    }
    //
    visits = await apiClient.getVisits(
        'day', GeneralHelper.formatDateForApi(DateTime.now()));
    createdVisitsLocationIds = [];
    for (int i = 0; i < visits.length; i++) {
      createdVisitsLocationIds.add(visits[i].location.id!);
    }
    //
    emit(ListTapContainerGetLocationsSuccessState(
        amLocations: amLocations, pmLocations: pmLocations));
  }

  isVisitCreated(int locationId) {
    return createdVisitsLocationIds.contains(locationId);
  }

  Future<bool> creteVisit(int visitId, int locationId, String type) async {
    emit(ListTapContainerLoading());

    final shift = type == "Hospital" ? "am" : "pm";
    final result = await apiClient.createVisit(
      repId!,
      locationId,
      GeneralHelper.formatDateForApi(DateTime.now()),
      shift,
    );
    await getAmAndPmLocations();
    emit(ListTapContainerGetLocationsSuccessState(
      amLocations: amLocations,
      pmLocations: pmLocations,
    ));
    return result;
  }

  bool isQuestionSubmitted(int locationId) {
    bool isQuestionSubmitted = false;
    for (int i = 0; i < visits.length; i++) {
      if (visits[i].location.id == locationId) {
        isQuestionSubmitted = visits[i].isQuestionSubmitted;
        break;
      }
    }

    return isQuestionSubmitted;
  }

  int getVisitId(int locationId) {
    int visitId = -1;
    for (int i = 0; i < visits.length; i++) {
      if (visits[i].location.id == locationId) {
        visitId = visits[i].id;
        break;
      }
    }
    return visitId;
  }

  searchInPmLocations(String value) {
    final list = pmLocations
        .where((element) => element.name.split('_').last.contains(value))
        .toList();
    emit(
      ListTapContainerGetLocationsSuccessState(
        pmLocations: list,
        amLocations: [],
      ),
    );
  }

  searchInAmLocations(String value) {
    final list = amLocations
        .where((element) => element.name.split('_').last.contains(value))
        .toList();
    emit(
      ListTapContainerGetLocationsSuccessState(
        amLocations: list,
        pmLocations: [],
      ),
    );
  }
}

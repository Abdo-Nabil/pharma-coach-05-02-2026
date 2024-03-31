import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import '../models/home_item_model.dart';
import 'package:mina_s_application5/presentation/home_page/models/home_model.dart';
import 'package:mina_s_application5/data/models/getLocations/get_get_locations_resp.dart';
import 'dart:async';
import 'package:mina_s_application5/data/repository/repository.dart';
part 'home_event.dart';
part 'home_state.dart';

/// A bloc that manages the state of a Home according to the event that is dispatched to it.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(HomeState initialState) : super(initialState) {
    on<HomeInitialEvent>(_onInitialize);
    on<FetchLocationsEvent>(_callGetLocations);
  }

  final _repository = Repository();

  var getGetLocationsResp = GetGetLocationsResp();

  /// Calls the {{baseUrl}}/locations?page=1&per_page=5 API and triggers a [FetchLocationsEvent] event on the [HomeBloc] bloc.
  ///
  /// The [BuildContext] parameter represents current [BuildContext]
  _onInitialize(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
        homeModelObj: state.homeModelObj?.copyWith(
      homeItemList: fillHomeItemList(),
    )));
    add(
      FetchLocationsEvent(),
    );
  }

  List<HomeItemModel> fillHomeItemList() {
    return [
      HomeItemModel(
          tareqFares: GetGetLocationsResp().message,
          oneMillionTwoHundredFiftyTwoTh: "12 - 5 - 2024"),
      HomeItemModel(
          tareqFares: "Tareq Fares ",
          oneMillionTwoHundredFiftyTwoTh: "20 - 5 - 2024"),
      HomeItemModel(
          tareqFares: "Marwa Mohamed",
          oneMillionTwoHundredFiftyTwoTh: "15 - 5 - 2024"),
      HomeItemModel(
          tareqFares: "Esraa Magdi",
          oneMillionTwoHundredFiftyTwoTh: "16 - 5 - 2024"),
      HomeItemModel(
          tareqFares: "Tareq Fares ",
          oneMillionTwoHundredFiftyTwoTh: "23 - 5 - 2024")
    ];
  }

  /// Calls [{{baseUrl}}/locations?page=1&per_page=5] with the provided event and emits the state.
  ///
  /// The [FetchLocationsEvent] parameter is used for handling event data
  /// The [emit] parameter is used for emitting the state
  ///
  /// Throws an error if an error occurs during the API call process.
  FutureOr<void> _callGetLocations(
    FetchLocationsEvent event,
    Emitter<HomeState> emit,
  ) async {
    var queryParams = <String, dynamic>{};
    await _repository.getLocations(
      headers: {'Content-Type': 'application/json',
    'Accept':'Accept',
    'Authorization': 'Bearer 18|pQn4a6znGuLLTmlP4Amc6iWmQKwUeHNIAdzfTd00be58e78f',

      },
      queryParams: queryParams,
    ).then((value) async {
      getGetLocationsResp = value;
      _onGetLocationsSuccess(value, emit);
    }).onError((error, stackTrace) {
      //implement error call
      _onGetLocationsError();
    });
  }

  void _onGetLocationsSuccess(
    GetGetLocationsResp resp,
    Emitter<HomeState> emit,
  ) {}
  void _onGetLocationsError() {
    //implement error method body...
  }
}

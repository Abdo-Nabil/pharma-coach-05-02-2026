import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import '../models/listone_item_model.dart';
import 'package:mina_s_application5/presentation/list_one_page/models/list_one_model.dart';
part 'list_one_event.dart';
part 'list_one_state.dart';

/// A bloc that manages the state of a ListOne according to the event that is dispatched to it.
class ListOneBloc extends Bloc<ListOneEvent, ListOneState> {
  ListOneBloc(ListOneState initialState) : super(initialState) {
    on<ListOneInitialEvent>(_onInitialize);
  }

  List<ListoneItemModel> fillListoneItemList() {
    return [
      ListoneItemModel(
          elgawyHospital: "Elgawy Hospital",
          nasrCityOne: "Nasr city 1",
          normal: "Normal",
          flash: "Flash"),
      ListoneItemModel(
          elgawyHospital: "New Cairo Hospital",
          nasrCityOne: "nasr city 1",
          normal: "Normal",
          flash: "Flash"),
      ListoneItemModel(
          elgawyHospital: "Nata",
          nasrCityOne: "Nasr city 1",
          normal: "Normal",
          flash: "Flash"),
      ListoneItemModel(
          elgawyHospital: "New Cairo Hospital",
          nasrCityOne: "nasr city 1",
          normal: "Normal",
          flash: "Flash")
    ];
  }

  _onInitialize(
    ListOneInitialEvent event,
    Emitter<ListOneState> emit,
  ) async {
    emit(state.copyWith(
      searchController: TextEditingController(),
    ));
    emit(state.copyWith(
        listOneModelObj: state.listOneModelObj?.copyWith(
      listoneItemList: fillListoneItemList(),
    )));
  }
}

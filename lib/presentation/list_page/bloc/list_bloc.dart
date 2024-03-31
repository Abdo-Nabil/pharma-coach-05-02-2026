import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import '../models/list_item_model.dart';
import 'package:mina_s_application5/presentation/list_page/models/list_model.dart';
part 'list_event.dart';
part 'list_state.dart';

/// A bloc that manages the state of a List according to the event that is dispatched to it.
class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc(ListState initialState) : super(initialState) {
    on<ListInitialEvent>(_onInitialize);
  }

  List<ListItemModel> fillListItemList() {
    return [
      ListItemModel(
          marwaMohamedEldeeb: "Marwa Mohamed Eldeeb  ",
          brickNasrCity: "Brick1 Nasr City",
          normal: "Normal",
          paediatrics: "Paediatrics",
          flash: "Flash"),
      ListItemModel(
          marwaMohamedEldeeb: "Marwa Mohamed Eldeeb ",
          brickNasrCity: "Brick1 Nasr City",
          normal: "Normal",
          paediatrics: "Paediatrics")
    ];
  }

  _onInitialize(
    ListInitialEvent event,
    Emitter<ListState> emit,
  ) async {
    emit(state.copyWith(
      searchController: TextEditingController(),
    ));
    emit(state.copyWith(
        listModelObj: state.listModelObj?.copyWith(
      listItemList: fillListItemList(),
    )));
  }
}

// ignore_for_file: must_be_immutable

part of 'list_tab_container_bloc.dart';

/// Represents the state of ListTabContainer in the application.
class ListTabContainerState extends Equatable {
  ListTabContainerState({this.listTabContainerModelObj});

  ListTabContainerModel? listTabContainerModelObj;

  @override
  List<Object?> get props => [
        listTabContainerModelObj,
      ];

  ListTabContainerState copyWith(
      {ListTabContainerModel? listTabContainerModelObj}) {
    return ListTabContainerState(
      listTabContainerModelObj:
          listTabContainerModelObj ?? this.listTabContainerModelObj,
    );
  }
}

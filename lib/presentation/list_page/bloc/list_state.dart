// ignore_for_file: must_be_immutable

part of 'list_bloc.dart';

/// Represents the state of List in the application.
class ListState extends Equatable {
  ListState({
    this.searchController,
    this.listModelObj,
  });

  TextEditingController? searchController;

  ListModel? listModelObj;

  @override
  List<Object?> get props => [
        searchController,
        listModelObj,
      ];

  ListState copyWith({
    TextEditingController? searchController,
    ListModel? listModelObj,
  }) {
    return ListState(
      searchController: searchController ?? this.searchController,
      listModelObj: listModelObj ?? this.listModelObj,
    );
  }
}

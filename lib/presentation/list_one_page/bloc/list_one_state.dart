// ignore_for_file: must_be_immutable

part of 'list_one_bloc.dart';

/// Represents the state of ListOne in the application.
class ListOneState extends Equatable {
  ListOneState({
    this.searchController,
    this.listOneModelObj,
  });

  TextEditingController? searchController;

  ListOneModel? listOneModelObj;

  @override
  List<Object?> get props => [
        searchController,
        listOneModelObj,
      ];

  ListOneState copyWith({
    TextEditingController? searchController,
    ListOneModel? listOneModelObj,
  }) {
    return ListOneState(
      searchController: searchController ?? this.searchController,
      listOneModelObj: listOneModelObj ?? this.listOneModelObj,
    );
  }
}

// ignore_for_file: must_be_immutable

part of 'add_medical_rep_bloc.dart';

/// Represents the state of AddMedicalRep in the application.
class AddMedicalRepState extends Equatable {
  AddMedicalRepState({
    this.searchController,
    this.addMedicalRepModelObj,
  });

  TextEditingController? searchController;

  AddMedicalRepModel? addMedicalRepModelObj;

  @override
  List<Object?> get props => [
        searchController,
        addMedicalRepModelObj,
      ];

  AddMedicalRepState copyWith({
    TextEditingController? searchController,
    AddMedicalRepModel? addMedicalRepModelObj,
  }) {
    return AddMedicalRepState(
      searchController: searchController ?? this.searchController,
      addMedicalRepModelObj:
          addMedicalRepModelObj ?? this.addMedicalRepModelObj,
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(GeneralInitial());

  int selectedIndexForListPage = 0;
  setSelectedIndexForListPage(value) {
    selectedIndexForListPage = value;
    emit(GeneralInitial());
  }

  //
  int bottomNavIndex = 0;
  setBottomNavIndex(value) {
    bottomNavIndex = value;
    emit(GeneralInitial());
  }
}

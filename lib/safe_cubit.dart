import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class SafeCubit<State> extends Cubit<State> {
  SafeCubit(State initialState) : super(initialState);
  //
  @override
  void emit(state) {
    if (isClosed) {
      debugPrint(
          "################# You can't call $state after closing the cubit");
      return;
    }
    super.emit(state);
  }
}

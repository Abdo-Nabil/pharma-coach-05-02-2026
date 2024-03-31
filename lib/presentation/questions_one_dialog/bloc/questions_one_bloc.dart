import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:mina_s_application5/presentation/questions_one_dialog/models/questions_one_model.dart';
part 'questions_one_event.dart';
part 'questions_one_state.dart';

/// A bloc that manages the state of a QuestionsOne according to the event that is dispatched to it.
class QuestionsOneBloc extends Bloc<QuestionsOneEvent, QuestionsOneState> {
  QuestionsOneBloc(QuestionsOneState initialState) : super(initialState) {
    on<QuestionsOneInitialEvent>(_onInitialize);
  }

  _onInitialize(
    QuestionsOneInitialEvent event,
    Emitter<QuestionsOneState> emit,
  ) async {}
}

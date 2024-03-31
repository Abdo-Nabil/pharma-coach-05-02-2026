import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/questions_model.dart';
part 'questions_event.dart';
part 'questions_state.dart';

/// A bloc that manages the state of a Questions according to the event that is dispatched to it.
class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  QuestionsBloc(QuestionsState initialState) : super(initialState) {
    on<QuestionsInitialEvent>(_onInitialize);
  }

  _onInitialize(
    QuestionsInitialEvent event,
    Emitter<QuestionsState> emit,
  ) async {
    emit(state.copyWith(
      activelisteningController: TextEditingController(),
      positioningBrandBenefitsController: TextEditingController(),
      closingController: TextEditingController(),
      bridgingToNextProductsController: TextEditingController(),
    ));
  }
}

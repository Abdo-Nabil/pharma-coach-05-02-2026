import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:mina_s_application5/presentation/final_quest_screen/models/final_quest_model.dart';
part 'final_quest_event.dart';
part 'final_quest_state.dart';

/// A bloc that manages the state of a FinalQuest according to the event that is dispatched to it.
class FinalQuestBloc extends Bloc<FinalQuestEvent, FinalQuestState> {
  FinalQuestBloc(FinalQuestState initialState) : super(initialState) {
    on<FinalQuestInitialEvent>(_onInitialize);
  }

  _onInitialize(
    FinalQuestInitialEvent event,
    Emitter<FinalQuestState> emit,
  ) async {
    emit(state.copyWith(
      coachingDaysFinalQuestionController: TextEditingController(),
    ));
  }
}

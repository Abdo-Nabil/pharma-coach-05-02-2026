import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/location_model.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/question_answer_model.dart';

import '../general_data.dart';
import '../presentation/questions_screen/models/answer_model.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  final ApiClient apiClient;
  GeneralCubit(this.apiClient) : super(GeneralInitial());

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
  //

  getQuestionsCategoriesForToday(String questionsType) async {
    final pref = PrefUtils();
    final categories = pref.getQuestionsCategories(questionsType);
    if (categories.isEmpty) {
      final categories = await apiClient.getQuestionCategories(questionsType);
      pref.saveQuestionsCategories(categories, questionsType);
    } else {
      return categories;
    }
  }

  Future<List<LocationModel>> getLocationsForToday() async {
    final pref = PrefUtils();
    List<LocationModel> locations = [];
    //
    locations = pref.getLocationsOfTodayForMedicalRep();
    final repId = pref.getRepIdForToday();
    GeneralData.selectedRepId = repId;

    if (locations.isEmpty) {
      //
      if (repId != -1) {
        locations = await apiClient.getRepLocations(repId);
        await pref.saveLocationsOfTodayForMedicalRep(locations);
      }
      //
    }
    debugPrint("############ Rep id :: ${repId.toString()}");
    //
    return locations;
  }

  executeSubmitQuestionsAndRemoveVisitsFromLocal() async {
    final pref = PrefUtils();
    if (!pref.isLastQuestionTodayAnswered()) {
      return;
    }
    //
    List<VisitInfoModel> visits = pref.getVisitsInLocalForToday();
    //
    for (int i = 0; i < visits.length; i++) {
      //
      List<QuestionAnswerModel> answersList =
          pref.getSingleVisitQuestionsAnswersLocally(visits[i].locationId);
      //
      if (visits[i].isVisitCreatedInServerAndQuestionSubmittedOnline) {
        continue;
      }
      final int? visitId = await apiClient.createVisit(
        GeneralData.selectedRepId,
        visits[i].locationId,
        // visits[i].visitTime,
        visits[i].accurateVisitTime,
        visits[i].shift,
        visits[i].questionType,
      );

      if (visitId != null) {
        //
        final answerModel = AnswerModel(
          visitId: visitId,
          repId: GeneralData.selectedRepId,
          answers: answersList,
        );

        final isSent = await apiClient.submitQuestionAnswers(answerModel);
        if (isSent) {
          await pref.updateSentVisitInLocalForToday(visits[i].locationId);
          await pref.saveVisitToFinishedVisitsList(GeneralData.selectedRepId);
        }
        //
      } else {
        break;
      }
    }
  }
}

//ignore: unused_import
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/intended_visit_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/location_model.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/answer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../general_helper.dart';
import '../../presentation/questions_screen/models/category_model.dart';
import '../../presentation/questions_screen/models/question_answer_model.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    // init();
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }

  setLoginToken(String token) {
    return _sharedPreferences!.setString("token", token);
  }

  String? getLoginToken() {
    try {
      return _sharedPreferences!.getString("token");
    } catch (e) {
      return null;
    }
  }

  setUserName(String username) {
    return _sharedPreferences!.setString("username", username);
  }

  String getUsername() {
    try {
      return _sharedPreferences!.getString("username")!;
    } catch (e) {
      return "My name";
    }
  }

  clearToken() async {
    await _sharedPreferences!.remove("token");
  }

  // the list is something like that ["52","iso8601Sate","77","iso8601Sate",....]
/*
  saveSubmittedVisitId(int visitId) async {
    List<String>? result = _sharedPreferences!.getStringList("visitIdsList");
    if (result == null) {
      await _sharedPreferences!.setStringList(
        "visitIdsList",
        [
          "$visitId",
          DateTime.now().toIso8601String(),
        ],
      );
    } else {
      DateTime theLastModifiedDate = DateTime.parse(result.last);
      if (theLastModifiedDate.add(Duration(days: 2)).isBefore(DateTime.now())) {
        result = [];
      }
      result.addAll([
        "$visitId",
        DateTime.now().toIso8601String(),
      ]);
      await _sharedPreferences!.setStringList("visitIdsList", result);
    }
  }
*/

/*
  bool isVisitSubmittedBefore(String visitId) {
    List<String>? result = _sharedPreferences!.getStringList("visitIdsList");
    if (result == null) {
      return false;
    } else {
      return result.contains(visitId);
    }
  }
*/

/*
  List getSubmittedQuestionsToBeExecuted() {
    final list =
        _sharedPreferences!.getStringList("submittedAnswersFailureList");
    if (list == null || list.isEmpty) {
      return [];
    } else {
      return list;
    }
  }
*/

/*saveSubmittedQuestionsForTheNextLaunchIfErrorHappen(
      String encodedData) async {
    List<String>? list =
        _sharedPreferences!.getStringList("submittedAnswersFailureList");
    if (list == null || list.isEmpty) {
      await _sharedPreferences!
          .setStringList("submittedAnswersFailureList", [encodedData]);
    } else {
      list.add(encodedData);
      await _sharedPreferences!
          .setStringList("submittedAnswersFailureList", list);
    }
  }*/

/*  removeSubmittedQuestion(String encodedData) async {
    List<String> list =
        _sharedPreferences!.getStringList("submittedAnswersFailureList")!;
    list.remove(encodedData);
    await _sharedPreferences!
        .setStringList("submittedAnswersFailureList", list);
  }*/

  //
  List<IntendedVisitModel> getIntendedVisits() {
    List<String>? list =
        _sharedPreferences!.getStringList("monthlyIntendedVisits");
    if (list == null) {
      return [];
    } else {
      List<IntendedVisitModel> temp = [];
      for (int i = 0; i < list.length; i++) {
        temp.add(IntendedVisitModel.fromMap(json.decode(list[i])));
      }
      return temp;
    }
  }

  Future<List<IntendedVisitModel>> getThisWeekIntendedVisits() async {
    final temp = DateTime.now();
    final dateNow = DateTime(temp.year, temp.month, temp.day);
    final dateAfter8Days = dateNow.add(Duration(days: 8));
    //
    List<IntendedVisitModel> intendedVisits = await getIntendedVisits();
    intendedVisits = intendedVisits.where((visit) {
      final visitDate = GeneralHelper.formatDateFromApi(visit.stringDate);
      if (visitDate.isAtSameMomentAs(dateNow) ||
          (visitDate.isBefore(dateAfter8Days) && visitDate.isAfter(dateNow))) {
        return true;
      }
      return false;
    }).toList();

    intendedVisits.sort((a, b) {
      return GeneralHelper.getDateTimeFromApiVisitTime(a.stringDate)
          .compareTo(GeneralHelper.getDateTimeFromApiVisitTime(b.stringDate));
    });
    return intendedVisits;
  }

  List<IntendedVisitModel> _getThisWeekIntendedVisitsForRep(
      int repId, List<IntendedVisitModel> list) {
    //
    final visitsForRep =
        list.where((element) => element.repId == repId).toList();
    return visitsForRep;
  }

  Future<List<int>> _getThisWeekRepsIds(List<IntendedVisitModel> visits) async {
    List<int> reps = [];
    for (int i = 0; i < visits.length; i++) {
      if (!reps.contains(visits[i].repId)) {
        reps.add(visits[i].repId);
      }
    }
    return reps;
  }

  Future<List<List<IntendedVisitModel>>> getThisWeekVisitsForEveryRep() async {
    final allVisits = await getThisWeekIntendedVisits();
    List<List<IntendedVisitModel>> list = [];
    //
    final reps = await _getThisWeekRepsIds(allVisits);
    for (int i = 0; i < reps.length; i++) {
      final temp = _getThisWeekIntendedVisitsForRep(reps[i], allVisits);
      list.add(temp);
    }
    return list;
  }

  //
  addNewIntendedVisit(IntendedVisitModel intendedVisitModel) async {
    List<IntendedVisitModel> list = getIntendedVisits();
    int index = list.indexWhere((item) {
      return intendedVisitModel.stringDate == item.stringDate;
    });
    //not found
    if (index == -1) {
      list.add(intendedVisitModel);
    } else {
      list[index] = intendedVisitModel;
    }
    await _saveIntendedVisitsLocally(list);
  }

  removeIntendedVisit(IntendedVisitModel intendedVisitModel) async {
    List<IntendedVisitModel> list = getIntendedVisits();
    list.removeWhere((IntendedVisitModel element) {
      return (element.repName == intendedVisitModel.repName &&
          element.repId == intendedVisitModel.repId &&
          element.stringDate == intendedVisitModel.stringDate);
    });
    await _saveIntendedVisitsLocally(list);
  }

  _saveIntendedVisitsLocally(List<IntendedVisitModel> list) async {
    List<String> temp = [];
    for (int i = 0; i < list.length; i++) {
      temp.add(json.encode(list[i].toMap()));
    }
    await _sharedPreferences!.setStringList("monthlyIntendedVisits", temp);
  }

/*  removeIntendedVisit(String isoDate) async {
    List<IntendedVisitModel> list = getIntendedVisits();
    list.removeWhere((item) {
      return item.stringDate == isoDate;
    });
    await _saveIntendedVisitsLocally(list);
  }*/

  /// Handling the question logic in 3 screens starts from here
  setFirstCategoryAnswer(List<QuestionAnswerModel> answers) async {
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    await _sharedPreferences!.setString("firstCategoryDate$todayDate",
        GeneralHelper.formatDateForApi(DateTime.now()));
    List<Map<String, dynamic>> maps = [];
    for (int i = 0; i < answers.length; i++) {
      maps.add(answers[i].toMap());
    }
    await _sharedPreferences!
        .setString("firstCategory$todayDate", json.encode(maps));
  }

  //This return a list of two question of the first category
  List<Map<String, dynamic>>? getFirstCategoryAnswer() {
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    String? date = _sharedPreferences!.getString(
      "firstCategoryDate$todayDate",
    );
    if (date == null) {
      return null;
    } else {
      if (date == GeneralHelper.formatDateForApi(DateTime.now())) {
        final temp = _sharedPreferences!.getString("firstCategory$todayDate")!;
        List<dynamic> listOfMaps = json.decode(temp);
        return listOfMaps.cast<Map<String, dynamic>>();
      }
      return null;
    }
  }

  saveQuestionsBlockForSingleVisit(
      int locationId, List<QuestionAnswerModel> answers) async {
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    List<Map<String, dynamic>> maps = [];
    for (int i = 0; i < answers.length; i++) {
      maps.add(answers[i].toMap());
    }
    //
    debugPrint("@@@@@@@@ saved visit with location id :: $locationId");
    await _sharedPreferences!
        .setString("${locationId}BlockFor$todayDate", json.encode(maps));
  }

  getQuestionsBlockForSingleVisit(int locationId) {
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    final temp =
        _sharedPreferences!.getString("${locationId}BlockFor$todayDate");
    if (temp == null) {
      debugPrint(
          "########## ########## ########## getQuestionsBlockForSingleVisit");
      return null;
    }
    List<dynamic> listOfMaps = json.decode(temp);
    return listOfMaps.cast<Map<String, dynamic>>();
  }

/*
  saveQuestionsBlockForSingleVisit(
      int visitId, List<QuestionAnswerModel> answers) async {
    List<Map<String, dynamic>> maps = [];
    for (int i = 0; i < answers.length; i++) {
      maps.add(answers[i].toMap());
    }
    //
    debugPrint("@@@@@@@@ saved visit id $visitId");
    await _sharedPreferences!.setString("$visitId", json.encode(maps));
  }

  getQuestionsBlockForSingleVisit(int visitId) {
    final temp = _sharedPreferences!.getString("$visitId");
    if (temp == null) {
      return null;
    }
    List<dynamic> listOfMaps = json.decode(temp);
    return listOfMaps.cast<Map<String, dynamic>>();
  }*/

  ///Full offline starts here
  ///
  ///
  int getRepIdForToday() {
    final temp = DateTime.now();
    final dateNow = DateTime(temp.year, temp.month, temp.day);
    //
    List<IntendedVisitModel> intendedVisits = getIntendedVisits();
    final intendedVisit = intendedVisits.firstWhere((visit) {
      final visitDate = GeneralHelper.formatDateFromApi(visit.stringDate);
      if (visitDate.isAtSameMomentAs(dateNow)) {
        return true;
      }
      return false;
    },
        orElse: () => IntendedVisitModel(
            repName: "repName", stringDate: "stringDate", repId: -1));

    return intendedVisit.repId;
  }

  saveQuestionsCategories(
      List<CategoryModel> categories, String questionType) async {
    List<String> encodedList = [];
    for (int i = 0; i < categories.length; i++) {
      encodedList.add(json.encode(categories[i].toMap()));
    }
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    await _sharedPreferences!
        .setStringList("${questionType}Questions$todayDate", encodedList);
  }

  List<CategoryModel> getQuestionsCategories(String questionType) {
    List<CategoryModel> categories = [];
    //
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    List<String>? encodedCategories =
        _sharedPreferences!.getStringList("${questionType}Questions$todayDate");
    //
    if (encodedCategories != null) {
      for (int i = 0; i < encodedCategories.length; i++) {
        categories
            .add(CategoryModel.fromMap(json.decode(encodedCategories[i])));
      }
      //
    }
    return categories;
  }

  saveLocationsOfTodayForMedicalRep(List<LocationModel> locations) async {
    List<String> encodedList = [];
    for (int i = 0; i < locations.length; i++) {
      encodedList.add(json.encode(locations[i].toMap()));
    }
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    await _sharedPreferences!
        .setStringList("locationsFor$todayDate", encodedList);
  }

  List<LocationModel> getLocationsOfTodayForMedicalRep() {
    List<LocationModel> locations = [];
    //
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    List<String>? encodedLocations =
        _sharedPreferences!.getStringList("locationsFor$todayDate");
    //
    if (encodedLocations != null) {
      for (int i = 0; i < encodedLocations.length; i++) {
        locations.add(LocationModel.fromMap(json.decode(encodedLocations[i])));
      }
      //
    }
    return locations;
  }

  bool isLastQuestionTodayAnswered() {
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    final result =
        _sharedPreferences?.getBool("isLastQuestionAnswered$todayDate");
    if (result == null) {
      return false;
    }
    return true;
  }

  setLastQuestionAsAnsweredToday() async {
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    await _sharedPreferences?.setBool("isLastQuestionAnswered$todayDate", true);
  }

  addVisitInLocalForToday(VisitInfoModel visitInfo) async {
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    List<String>? encodedVisitsInfo =
        _sharedPreferences!.getStringList("visitsInfo$todayDate");
    //
    if (encodedVisitsInfo == null) {
      await _sharedPreferences!.setStringList(
        "visitsInfo$todayDate",
        [json.encode(visitInfo.toMap())],
      );
    } else {
      if (encodedVisitsInfo.contains(json.encode(visitInfo.toMap()))) {
        debugPrint('############## visit added previously!!!');
        return;
      }
      encodedVisitsInfo.add(json.encode(visitInfo.toMap()));
      await _sharedPreferences!.setStringList(
        "visitsInfo$todayDate",
        encodedVisitsInfo,
      );
    }
  }

  List<VisitInfoModel> getVisitsInLocalForToday() {
    List<VisitInfoModel> visitsInfo = [];
    //
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    List<String>? encodedVisitsInfo =
        _sharedPreferences!.getStringList("visitsInfo$todayDate");
    //
    if (encodedVisitsInfo != null) {
      for (int i = 0; i < encodedVisitsInfo.length; i++) {
        visitsInfo
            .add(VisitInfoModel.fromMap(json.decode(encodedVisitsInfo[i])));
      }
    }
    return visitsInfo;
  }

  updateSentVisitInLocalForToday(int locationId) async {
    List<Map<String, dynamic>> visitsInfo = [];
    //
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    List<String>? encodedVisitsInfo =
        _sharedPreferences!.getStringList("visitsInfo$todayDate");
    //
    if (encodedVisitsInfo != null) {
      //
      for (int i = 0; i < encodedVisitsInfo.length; i++) {
        visitsInfo.add(json.decode(encodedVisitsInfo[i]));
      }

      final visitIndexToUpdate = visitsInfo
          .indexWhere((element) => element["locationId"] == locationId);
      final visitToUpdate = visitsInfo[visitIndexToUpdate];
      visitToUpdate["isVisitCreatedInServerAndQuestionSubmittedOnline"] = true;
      visitsInfo[visitIndexToUpdate] = visitToUpdate;
      //
      List<String> temp = [];
      for (int i = 0; i < visitsInfo.length; i++) {
        temp.add(json.encode(visitsInfo[i]));
      }
      await _sharedPreferences?.setStringList("visitsInfo$todayDate", temp);
    }
  }

  saveSingleVisitQuestionsAnswersLocally(
      List<Map<String, dynamic>> visitAnswers, int locationId) async {
    //
    List<String> encodedAnswers = [];
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    //
    for (int i = 0; i < visitAnswers.length; i++) {
      encodedAnswers.add(json.encode(visitAnswers[i]));
    }
    //
    await _sharedPreferences?.setStringList(
        "visitQuestionsAnswers$locationId$todayDate", encodedAnswers);
  }

  List<QuestionAnswerModel> getSingleVisitQuestionsAnswersLocally(
      int locationId) {
    String todayDate = GeneralHelper.formatDateForApi(DateTime.now());
    List<String>? visitAnswersList = _sharedPreferences
        ?.getStringList("visitQuestionsAnswers$locationId$todayDate");
    List<QuestionAnswerModel> answers = [];
    //
    if (visitAnswersList != null) {
      for (int i = 0; i < visitAnswersList.length; i++) {
        answers
            .add(QuestionAnswerModel.fromMap(json.decode(visitAnswersList[i])));
      }
    }

    //
    return answers;
  }
}

class VisitInfoModel {
  final int repId;
  final int locationId;
  final String visitTime;
  final String accurateVisitTime;
  final String shift;
  final bool isQuestionSubmitted;
  final bool isVisitCreatedInServerAndQuestionSubmittedOnline;

  const VisitInfoModel({
    required this.repId,
    required this.locationId,
    required this.visitTime,
    required this.accurateVisitTime,
    required this.shift,
    required this.isQuestionSubmitted,
    this.isVisitCreatedInServerAndQuestionSubmittedOnline = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'repId': this.repId,
      'locationId': this.locationId,
      'visitTime': this.visitTime,
      'accurateVisitTime': this.accurateVisitTime,
      'shift': this.shift,
      'isQuestionSubmitted': this.isQuestionSubmitted,
      'isVisitCreatedInServerAndQuestionSubmittedOnline':
          this.isVisitCreatedInServerAndQuestionSubmittedOnline,
    };
  }

  factory VisitInfoModel.fromMap(Map<String, dynamic> map) {
    return VisitInfoModel(
      repId: map['repId'] as int,
      locationId: map['locationId'] as int,
      visitTime: map['visitTime'] as String,
      accurateVisitTime: map['accurateVisitTime'] as String,
      shift: map['shift'] as String,
      isQuestionSubmitted: map['isQuestionSubmitted'] as bool,
      isVisitCreatedInServerAndQuestionSubmittedOnline:
          map['isVisitCreatedInServerAndQuestionSubmittedOnline'] as bool,
    );
  }
}

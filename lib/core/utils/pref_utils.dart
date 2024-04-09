//ignore: unused_import
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/intended_visit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../general_helper.dart';

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

  bool isVisitSubmittedBefore(String visitId) {
    List<String>? result = _sharedPreferences!.getStringList("visitIdsList");
    if (result == null) {
      return false;
    } else {
      return result.contains(visitId);
    }
  }

  List getSubmittedQuestionsToBeExecuted() {
    final list =
        _sharedPreferences!.getStringList("submittedAnswersFailureList");
    if (list == null || list.isEmpty) {
      return [];
    } else {
      return list;
    }
  }

  saveSubmittedQuestionsForTheNextLaunchIfErrorHappen(
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
  }

  removeSubmittedQuestion(String encodedData) async {
    List<String> list =
        _sharedPreferences!.getStringList("submittedAnswersFailureList")!;
    list.remove(encodedData);
    await _sharedPreferences!
        .setStringList("submittedAnswersFailureList", list);
  }

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

  _saveIntendedVisitsLocally(List<IntendedVisitModel> list) async {
    List<String> temp = [];
    for (int i = 0; i < list.length; i++) {
      temp.add(json.encode(list[i].toMap()));
    }
    await _sharedPreferences!.setStringList("monthlyIntendedVisits", temp);
  }

  removeIntendedVisit(String isoDate) async {
    List<IntendedVisitModel> list = getIntendedVisits();
    list.removeWhere((item) {
      return item.stringDate == isoDate;
    });
    await _saveIntendedVisitsLocally(list);
  }
}

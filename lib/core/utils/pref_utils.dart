//ignore: unused_import
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/intended_visit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<IntendedVisitModel> getMonthlyIntendedVisits() {
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

  //
  addNewIntendedVisit(IntendedVisitModel intendedVisitModel) async {
    List<IntendedVisitModel> list = getMonthlyIntendedVisits();
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
    List<IntendedVisitModel> list = getMonthlyIntendedVisits();
    list.removeWhere((item) {
      return item.stringDate == isoDate;
    });
    await _saveIntendedVisitsLocally(list);
  }
}

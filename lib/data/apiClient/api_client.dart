import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/data/models/getLocations/get_get_locations_resp.dart';
import 'package:mina_s_application5/data/models/loginUser/post_login_user_resp.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/location_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/rep_model.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/answer_model.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/calendar_container_screen/models/vsit_model.dart';
import '../../presentation/team_analytics_screen/models/rep_analysis_model.dart';
import '../../presentation/team_analytics_screen/models/team_analysis_model.dart';
import 'network_interceptor.dart';

class ApiClient {
  factory ApiClient() {
    return _apiClient;
  }

  ApiClient._internal();

  // var url = "http://37.61.217.36:8090/Pharcoo-master/public/index.php/api/v1";
  var url = "http://169.239.37.101:8090/Pharcoo-master/public/index.php/api/v1";

  static final ApiClient _apiClient = ApiClient._internal();

  final _dio = Dio(BaseOptions(
      // connectTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 5),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }))
    ..interceptors.add(NetworkInterceptor());

  ///method can be used for checking internet connection
  ///returns [bool] based on availability of internet
  Future isNetworkConnected() async {
    if (!await NetworkInfo().isConnected()) {
      throw NoInternetException('No Internet Found!');
    }
  }

  /// is `true` when the response status code is between 200 and 299
  ///
  /// user can modify this method with custom logics based on their API response
  bool _isSuccessCall(Response response) {
    if (response.statusCode != null) {
      return response.statusCode! >= 200 && response.statusCode! <= 299;
    }
    return false;
  }

  /// Performs API call for {{baseUrl}}/locations?page=1&per_page=5
  ///
  /// Sends a GET request to the server's '{{baseUrl}}/locations?page=1&per_page=5' endpoint
  /// with the provided headers and request data
  /// Returns a [GetGetLocationsResp] object representing the response.
  /// Throws an error if the request fails or an exception occurs.
  Future<GetGetLocationsResp> getLocations({
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParams = const {},
  }) async {
    // ProgressDialogUtils.showProgressDialog();
    try {
      await isNetworkConnected();
      Response response = await _dio.get(
        '$url/locations',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      ProgressDialogUtils.hideProgressDialog();
      if (_isSuccessCall(response)) {
        return GetGetLocationsResp.fromJson(response.data);
      } else {
        throw response.data != null
            ? GetGetLocationsResp.fromJson(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs API call for {{baseUrl}}/login
  ///
  /// Sends a POST request to the server's '{{baseUrl}}/login' endpoint
  /// with the provided headers and request data
  /// Returns a [PostLoginUserResp] object representing the response.
  /// Throws an error if the request fails or an exception occurs.
  Future<PostLoginUserResp> loginUser(
    String us,
    String pass, {
    Map<String, String> headers = const {
      'Content-Type': 'application/json',
      'Accept': 'Accept'
    },
    Map requestData = const {},
  }) async {
    ProgressDialogUtils.showProgressDialog();
    try {
      await isNetworkConnected();
      var response = await _dio.post(
        // '$url/login?email=a@b.com&password=adminadmin',
        // '$url/login?email=$us@pharcoo.com&password=$pass',
        '$url/login?email=$us@gmail.com&password=$pass',
        // data: requestData,

        options: Options(headers: headers),
      );
      // ProgressDialogUtils.hideProgressDialog();

      if (_isSuccessCall(response)) {
        final temp = PostLoginUserResp.fromJson(response.data);
        GeneralData.userName = temp.data!.email!.split("@").first;
        GeneralData.token = temp.data!.authToken;
        debugPrint('Auth token @@@ ${temp.data!.authToken}');
        //
        final sharedPref = await PrefUtils();
        await sharedPref.setLoginToken(GeneralData.token!);
        await sharedPref.setUserName(GeneralData.userName!);
        //
        ProgressDialogUtils.hideProgressDialog();
        NavigatorService.popAndPushNamed(
          AppRoutes.homeContainerScreen,
          arguments: temp,
        );

        return temp;
      } else {
        throw response.data != null
            ? PostLoginUserResp.fromJson(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

/*
  uploadSubmittedQuestionThatSavedLocallyPreviously() async {
    debugPrint('################### 1 Resend submitted QS');
    final shared = PrefUtils();
    final list = shared.getSubmittedQuestionsToBeExecuted();
    if (list.isEmpty) {
      debugPrint('################### 2 Resend submitted QS');
      return;
    } else {
      debugPrint('################### 3 Resend submitted QS');
      list.forEach(
        (encodedElement) async {
          final decodedElement = json.decode(encodedElement);
          final answerModel = AnswerModel.fromMap(decodedElement);
          debugPrint(
              "################### 4 Resend submitted QS ${decodedElement}");
          final isSend = await submitQuestionAnswers(answerModel,
              saveFailedTransaction: false);
          if (isSend) {
            debugPrint('################### 5 Resend submitted QS');
            shared.removeSubmittedQuestion(encodedElement);
          } else {
            debugPrint('################### 6 Resend submitted QS');
          }
        },
      );
    }
  }
*/

/*
  Future<List<VisitModel>> getVisits(String param, String date) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };
    Map<String, dynamic> queryParams = {
      "date": date,
      // "date": "02-04-2024",
      "date_scope": param,
    };
    try {
      await isNetworkConnected();
      //
      //TODO: move this line from here
      // await _uploadSubmittedQuestionThatSavedLocallyPreviously();
      //
      Response response = await _dio.get(
        '$url/visits/today',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (_isSuccessCall(response)) {
        List<VisitModel> visits = [];
        for (int i = 0; i < response.data["data"].length; i++) {
          final visit = VisitModel.fromMap(response.data["data"][i]);
          final pref = PrefUtils();
          final isQuestionSubmitted =
              pref.isVisitSubmittedBefore("${visit.id}");
          visits.add(visit.copyWith(isQuestionSubmitted: isQuestionSubmitted));
        }
        return visits;
      } else {
        throw response.data != null
            ? VisitModel.fromMap(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
*/

  Future<List<TinyRepModel>> getMedicalReps() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };
    Map<String, dynamic> queryParams = const {};
    try {
      await isNetworkConnected();
      Response response = await _dio.get(
        '$url/reps',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (_isSuccessCall(response)) {
        List<TinyRepModel> reps = [];
        for (int i = 0; i < response.data["data"].length; i++) {
          reps.add(TinyRepModel.fromMap(response.data["data"][i]));
        }
        return reps;
      } else {
        throw response.data != null
            ? RepModel.fromMap(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
  // Future<List<RepModel>> getMedicalReps() async {
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${GeneralData.token!}',
  //   };
  //   Map<String, dynamic> queryParams = const {};
  //   try {
  //     await isNetworkConnected();
  //     Response response = await _dio.get(
  //       '$url/reps',
  //       queryParameters: queryParams,
  //       options: Options(headers: headers),
  //     );
  //     if (_isSuccessCall(response)) {
  //       List<RepModel> reps = [];
  //       for (int i = 0; i < response.data["data"].length; i++) {
  //         reps.add(RepModel.fromMap(response.data["data"][i]));
  //       }
  //       return reps;
  //     } else {
  //       throw response.data != null
  //           ? RepModel.fromMap(response.data)
  //           : 'Something Went Wrong!';
  //     }
  //   } catch (error, stackTrace) {
  //     // ProgressDialogUtils.hideProgressDialog();
  //     Logger.log(
  //       error,
  //       stackTrace: stackTrace,
  //     );
  //     rethrow;
  //   }
  // }

  Future<List<LocationModel>> getRepLocations(int repId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };
    Map<String, dynamic> queryParams = {
      "rep_id": repId,
      "per_page": 200,
    };
    try {
      await isNetworkConnected();
      Response response = await _dio.get(
        '$url/locations',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (_isSuccessCall(response)) {
        List<LocationModel> locations = [];
        for (int i = 0; i < response.data["data"]["data"].length; i++) {
          locations
              .add(LocationModel.fromMap(response.data["data"]["data"][i]));
        }
        return locations;
      } else {
        throw response.data != null
            ? RepModel.fromMap(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<int?> createVisit(int repId, int locationId, String visitTime,
      String shift, String questionType) async {
    //
    int? visitId;
    //
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };
    Map<String, dynamic> queryParams = {
      "rep_id": repId,
      "location_id": locationId,
      "shift": shift,
      "question_type": questionType,
      "visit_time": visitTime,
      "name": "eg.visit name",
    };
    //
    try {
      // await isNetworkConnected();
      Response response = await _dio.get(
        '$url/visits/create',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (_isSuccessCall(response)) {
        //
        log("${response.data}");
        debugPrint("Visit created successfully");
        visitId = response.data["data"]["id"];
      } else {
        // throw response.data != null
        //     ? RepModel.fromMap(response.data)
        //     : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // ProgressDialogUtils.hideProgressDialog();
      debugPrint("############### Error createVisit");
      // Logger.log(
      //   error,
      //   stackTrace: stackTrace,
      // );
    }
    return visitId;
  }

  Future<List<CategoryModel>> getQuestionCategories(
      String questionsType) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };
    Map<String, dynamic> queryParams = {
      "type": questionsType,
    };
    try {
      await isNetworkConnected();
      Response response = await _dio.get(
        '$url/questions/all',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (_isSuccessCall(response)) {
        List<CategoryModel> categories = [];
        for (int i = 0; i < response.data["data"].length; i++) {
          categories.add(CategoryModel.fromMap(response.data["data"][i]));
        }

        return categories;
      } else {
        throw response.data != null
            ? RepModel.fromMap(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> submitQuestionAnswers(AnswerModel answerModel,
      {bool saveFailedTransaction = true}) async {
    bool isSend = false;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };
    Map<String, dynamic> queryParams = {};
    final encodedData = json.encode(
      answerModel.toMap(),
    );
    log("###################### ${encodedData}");
    try {
      // await isNetworkConnected();
      Response response = await _dio.get(
        '$url/questions/answer',
        queryParameters: queryParams,
        options: Options(headers: headers),
        data: encodedData,
      );
      if (_isSuccessCall(response)) {
        log(response.data.toString());
        isSend = true;
        debugPrint("############### SUCCESSFULLY submitQuestionAnswers");
      } else {
        // throw response.data != null
        //     ? RepModel.fromMap(response.data)
        //     : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // if (saveFailedTransaction) {
      //save the request in sharedpref to next launch
      // await pref
      //     .saveSubmittedQuestionsForTheNextLaunchIfErrorHappen(encodedData);
      // }
      debugPrint("############### Error submitQuestionAnswers");

      // Logger.log(
      //   error,
      //   stackTrace: stackTrace,
      // );
      // rethrow;
    }
    //
    // await pref.saveSubmittedVisitId(answerModel.visitId);
    //
    return isSend;
  }

  Future<List<TeamAnalysisModel>> getTeamAnalysis(
      String date, String dateScope) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };
    Map<String, dynamic> queryParams = {
      "date": date,
      "date_scope": dateScope,
    };
    try {
      await isNetworkConnected();
      Response response = await _dio.get(
        '$url/feedback',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (_isSuccessCall(response)) {
        List<TeamAnalysisModel> models = [];
        for (int i = 0; i < response.data["data"].length; i++) {
          models.add(TeamAnalysisModel.fromMap(response.data["data"][i]));
        }
        return models;
      } else {
        throw response.data != null
            ? RepModel.fromMap(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<RepAnalysisModel>> getRepAnalysis(
      String date, String dateScope) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };

    Map<String, dynamic> queryParams = {
      "date": date,
      "date_scope": dateScope,
    };
    try {
      await isNetworkConnected();
      Response response = await _dio.get(
        '$url/new-feedback',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (_isSuccessCall(response)) {
        List<RepAnalysisModel> models = [];
        for (int i = 0; i < response.data["data"].length; i++) {
          models.add(RepAnalysisModel.fromMap(
              response.data["data"][i],
              response.data["average_rep_percentages"],
              response.data["normal_calls %"]));
        }
        // for (int i = 0; i < data.length; i++) {
        //   models.add(RepAnalysisModel.fromMap(data[i], avg));
        // }
        return models;
      } else {
        throw response.data != null
            ? RepModel.fromMap(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<RepAnalysisModel>> getAvgRepAnalysis(
      String date, String dateScope, List<int> selectedRepIds) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };

    Map<String, dynamic> queryParams = {
      "date": date,
      "date_scope": dateScope,
    };
    try {
      await isNetworkConnected();
      Response response = await _dio.get(
        '$url/new-feedback',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (_isSuccessCall(response)) {
        List<RepAnalysisModel> models = [];
        //
        if (response.data['data'].isEmpty) {
          return models;
        }
        //
        final convertedSchema =
            _convertSchema(response.data, dateScope, selectedRepIds);
        // log('@@@@@######@@@@@ converted schema \n$convertedSchema');
        for (int i = 0; i < convertedSchema["data"].length; i++) {
          models.add(
            RepAnalysisModel.fromMap(
                convertedSchema["data"][i],
                convertedSchema["average_rep_percentages"],
                convertedSchema["normal_calls %"]),
          );
        }
        // for (int i = 0; i < data.length; i++) {
        //   models.add(RepAnalysisModel.fromMap(data[i], avg));
        // }
        return models;
      } else {
        throw response.data != null
            ? RepModel.fromMap(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Map<String, dynamic> _convertSchema(Map<String, dynamic> oldSchema,
      String dateScope, List<int> selectedRepIds) {
    if (dateScope == 'year') {
      return _convertToYearSchema(oldSchema, selectedRepIds);
    } else if (dateScope == 'month') {
      return _convertToMonthOrQuarterSchema(oldSchema, selectedRepIds, 12);
    } else {
      return _convertToMonthOrQuarterSchema(oldSchema, selectedRepIds, 3);
    }
  }

  Map<String, dynamic> _convertToYearSchema(
      Map<String, dynamic> oldSchema, List<int> selectedRepIds) {
    //
    //
    final oldDataListOfMaps = oldSchema["data"];
    List<Map<String, dynamic>> newDataListOfMaps = [];
    //
    for (int i = 0; i < oldDataListOfMaps.length; i++) {
      Map<String, dynamic> newMap = {};
      newMap["category"] = oldDataListOfMaps[i]["category"];
      // get number of question inside this category
      final int numOfQuestions = oldDataListOfMaps[i]["reps"]
          .entries
          .first
          .value
          .entries
          .first
          .value["Questions"]
          .entries
          .length;
      // variables to store sum
      List sumForQuestionsList = List.generate(numOfQuestions, (index) => 0.0);
      double sumForRepPercentage = 0;
      //
      for (int k = 0; k < selectedRepIds.length; k++) {
        //
        final Map? temp = oldDataListOfMaps[i]["reps"]["${selectedRepIds[k]}"];
        if (temp != null) {
          int index = 0;
          temp.entries.first.value["Questions"].entries.forEach((mapEntry) {
            sumForQuestionsList[index] += mapEntry.value;
            index++;
          });
          sumForRepPercentage += temp.entries.first.value["rep_percentage"];
        }
      }
      //
      List avgForQuestionsList = sumForQuestionsList;
      for (int z = 0; z < avgForQuestionsList.length; z++) {
        if (avgForQuestionsList[z] != 0) {
          avgForQuestionsList[z] = GeneralHelper.formatDoubleAsFixed(
              avgForQuestionsList[z] / selectedRepIds.length);
        }
      }
      //
      Map oldQuestionsMap = oldDataListOfMaps[i]["reps"]
          .entries
          .first
          .value
          .entries
          .first
          .value["Questions"];

      int index = 0;
      Map newQuestionsMap = {};
      oldQuestionsMap.forEach((key, value) {
        newQuestionsMap[key] = avgForQuestionsList[index];
        index++;
      });

      //
      double avgForRepPercentage = 0;
      if (sumForRepPercentage != 0) {
        avgForRepPercentage = GeneralHelper.formatDoubleAsFixed(
            sumForRepPercentage / selectedRepIds.length);
      }
      //
      newMap["reps"] = {
        "avg": {
          "anyYear": {
            "Questions": newQuestionsMap,
            "rep_percentage": avgForRepPercentage,
          },
        },
      };
      // debugPrint("########## Year Result \n ${newMap}");
      newDataListOfMaps.add(newMap);
    }
    //
    //
    double normalCalsAvg =
        _getAvgOfYearDirectMap(oldSchema["normal_calls %"], selectedRepIds);
    final newNormalCallsMap = {"avg": normalCalsAvg};
    //
    double repPercentageAvg = _getAvgOfYearDirectMap(
        oldSchema["average_rep_percentages"], selectedRepIds);
    final newAvgRepPercentageMap = {"avg": repPercentageAvg};
    //
    return {
      "data": newDataListOfMaps,
      "normal_calls %": newNormalCallsMap,
      "average_rep_percentages": newAvgRepPercentageMap,
    };
  }

  Map<String, dynamic> _convertToMonthOrQuarterSchema(
      Map<String, dynamic> oldSchema,
      List<int> selectedRepIds,
      int numOfMonths) {
    //
    //
    final oldDataListOfMaps = oldSchema["data"];
    List<Map<String, dynamic>> newDataListOfMaps = [];
    //
    for (int i = 0; i < oldDataListOfMaps.length; i++) {
      Map<String, dynamic> newMap = {};
      newMap["category"] = oldDataListOfMaps[i]["category"];
      // get number of question inside this category
      final int numOfQuestions = oldDataListOfMaps[i]["reps"]
          .entries
          .first
          .value
          .entries
          .first
          .value["Questions"]
          .entries
          .length;
      // variables to store sum
      //This will be a nested list lie this for example for a category with 2 questions
      // [ [ 95, 58] , [ 98, 63] , [ 85, 77], ...... ]
      //

      List sumForQuestionsList = List.generate(numOfMonths, (index) {
        return List.generate(numOfQuestions, (index) => 0.0);
      });
      //
      List sumForRepPercentage = List.generate(numOfMonths, (index) => 0.0);
      //
      for (int k = 0; k < selectedRepIds.length; k++) {
        //
        final Map? temp = oldDataListOfMaps[i]["reps"]["${selectedRepIds[k]}"];
        if (temp != null) {
          //
          int outerIndex = 0;
          temp.forEach((key, value) {
            int innerIndex = 0;
            value["Questions"].entries.forEach((mapEntry) {
              sumForQuestionsList[outerIndex][innerIndex] += mapEntry.value;
              innerIndex++;
            });
            sumForRepPercentage[outerIndex] += value["rep_percentage"];
            outerIndex++;
          });
          //
        }
      }
      //
      List avgForQuestionsList = sumForQuestionsList;
      for (int z = 0; z < avgForQuestionsList.length; z++) {
        for (int x = 0; x < avgForQuestionsList[z].length; x++) {
          if (avgForQuestionsList[z][x] != 0) {
            avgForQuestionsList[z][x] = GeneralHelper.formatDoubleAsFixed(
                avgForQuestionsList[z][x] / selectedRepIds.length);
          }
        }
      }
      //
      //
      List avgForRepPercentage = sumForRepPercentage;
      for (int f = 0; f < avgForRepPercentage.length; f++) {
        if (avgForRepPercentage[f] != 0) {
          avgForRepPercentage[f] = GeneralHelper.formatDoubleAsFixed(
              avgForRepPercentage[f] / selectedRepIds.length);
        }
      }
      //
      ///
      Map tempOldMonthsMap = oldDataListOfMaps[i]["reps"].entries.first.value;

      Map<String, dynamic> tempNewMonthsMap = {};
      int outerIndex = 0;
      tempOldMonthsMap.forEach((key, value) {
        int innerIndex = 0;
        Map<String, dynamic> questionsMap = {};
        value["Questions"].forEach((key, value) {
          questionsMap[key] = avgForQuestionsList[outerIndex][innerIndex];
          innerIndex++;
        });
        tempNewMonthsMap[key] = {
          "Questions": questionsMap,
          "rep_percentage": avgForRepPercentage[outerIndex],
        };
        outerIndex++;
      });
      //
      newMap["reps"] = {
        "avg": tempNewMonthsMap,
      };
      //
      // debugPrint("########## Quarter or Month Result \n ${newMap}");
      newDataListOfMaps.add(newMap);
    }
    //
    //
    Map<String, dynamic> normalCalsAvg = _getAvgOfQuarterAndMonthMap(
        oldSchema["normal_calls %"], selectedRepIds, numOfMonths);

    Map<String, dynamic> repPercentageAvg = _getAvgOfQuarterAndMonthMap(
        oldSchema["average_rep_percentages"], selectedRepIds, numOfMonths);
    //
    return {
      "data": newDataListOfMaps,
      "normal_calls %": normalCalsAvg,
      "average_rep_percentages": repPercentageAvg,
    };
  }

  double _getAvgOfYearDirectMap(
      Map<String, dynamic> map, List<int> selectedRepIds) {
    //
    if (map.isEmpty) return 0.0;
    //
    double sum = 0;
    for (int i = 0; i < selectedRepIds.length; i++) {
      final temp = map['${selectedRepIds[i]}'];
      if (temp != null) {
        sum += temp;
      }
    }
    if (sum == 0) {
      return 0;
    } else {
      return GeneralHelper.formatDoubleAsFixed(sum / selectedRepIds.length);
    }
  }

  Map<String, dynamic> _getAvgOfQuarterAndMonthMap(
      Map<String, dynamic> map, List<int> selectedRepIds, int numOfMonths) {
    //
    if (map.isEmpty) return {};
    //
    List<double> sumOfQuartersList = List.generate(numOfMonths, (index) => 0.0);
    for (int i = 0; i < selectedRepIds.length; i++) {
      final Map? temp = map['${selectedRepIds[i]}'];
      if (temp != null) {
        int index = 0;
        temp.forEach((key, value) {
          sumOfQuartersList[index] += value;
          index++;
        });
      }
    }
    //
    List<double> avgOfQuartersList = sumOfQuartersList;
    for (int i = 0; i < avgOfQuartersList.length; i++) {
      if (avgOfQuartersList[i] != 0.0) {
        avgOfQuartersList[i] = GeneralHelper.formatDoubleAsFixed(
            avgOfQuartersList[i] / selectedRepIds.length);
      }
    }
    Map<String, dynamic> newMap = {};
    int index = 0;
    map.entries.first.value.forEach((key, value) {
      newMap[key] = avgOfQuartersList[index];
      index++;
    });
    return {"avg": newMap};
  }

/*  Future<List<RepAnalysisModel>> getAvgRepAnalysis(
      String date, String dateScope, List<int> selectedRepIds) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeneralData.token!}',
    };

    // Map<String, dynamic> queryParams = {
    //   "date": date,
    //   "date_scope": dateScope,
    // };
    // for (int i = 0; i < selectedRepIds.length; i++) {
    //   queryParams["rep_ids[]"] = selectedRepIds[i];
    // }
    String link =
        '$url/new-feedback/with-rep-ids?date=$date&date_scope=$dateScope';
    for (int i = 0; i < selectedRepIds.length; i++) {
      link = '$link&rep_ids[]=${selectedRepIds[i]}';
    }

    debugPrint("############### ${link}");
    try {
      await isNetworkConnected();
      Response response = await _dio.get(
        link,
        // queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (_isSuccessCall(response)) {
        List<RepAnalysisModel> models = [];
        for (int i = 0; i < response.data["data"].length; i++) {
          models.add(RepAnalysisModel.fromMap(
              response.data["data"][i],
              response.data["average_rep_percentages"],
              response.data["normal_calls %"]));
        }
        */ /*for (int i = 0; i < avgsDataMonth["data"].length; i++) {
          models.add(RepAnalysisModel.fromMap(
              avgsDataMonth["data"][i],
              avgsDataMonth["average_rep_percentages"],
              avgsDataMonth["normal_calls %"]));
        }*/ /*
        // for (int i = 0; i < data.length; i++) {
        //   models.add(RepAnalysisModel.fromMap(data[i], avg));
        // }
        return models;
      } else {
        throw response.data != null
            ? RepModel.fromMap(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      // ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }*/
}

final Map avgsDataYear = {
  "status": "Success",
  "statusCode": 200,
  "message": "Feedback Retrieved successfully",
  "data": [
    {
      "category": "Personal Attributes",
      "reps": {
        "avg": {
          "2024": {
            "Questions": {"Punctuality": 100, "Dress code": 100},
            "rep_percentage": 100
          }
        },
      }
    },
    {
      "category": "Pharmacy Feedback",
      "reps": {
        "avg": {
          "2024": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 50
            },
            "rep_percentage": 50
          }
        },
      }
    },
    {
      "category": "Pre-Call Planning",
      "reps": {
        "avg": {
          "2024": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 50
            },
            "rep_percentage": 25
          }
        },
      }
    },
  ],
  "normal_calls %": {
    "avg": 92.2,
  },
  "average_rep_percentages": {
    "avg": 74.4,
  }
};

final Map avgsDataMonth = {
  "status": "Success",
  "statusCode": 200,
  "message": "Feedback Retrieved successfully",
  "data": [
    {
      "category": "Personal Attributes",
      "reps": {
        "avg": {
          "January": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          },
          "February": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          },
          "March": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          },
          "April": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          },
          "May": {
            "Questions": {"Punctuality": 97.8, "Dress code": 88.9},
            "rep_percentage": 94.4
          },
          "June": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 50,
          },
          "July": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          },
          "August": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          },
          "September": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          },
          "October": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          },
          "November": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          },
          "December": {
            "Questions": {"Punctuality": 0, "Dress code": 0},
            "rep_percentage": 0
          }
        },
      }
    },
    {
      "category": "Pharmacy Feedback",
      "reps": {
        "avg": {
          "May": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 97.6
            },
            "rep_percentage": 100
          },
          "January": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "February": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "March": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "April": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "June": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "July": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "August": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "September": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "October": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "November": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          },
          "December": {
            "Questions": {
              "Rate / Stock our Brands Vs Rate / Stock Competitors": 0
            },
            "rep_percentage": 0
          }
        },
      }
    },
    {
      "category": "Pre-Call Planning",
      "reps": {
        "avg": {
          "May": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 90.1,
              "Set SMART call objectives": 89.9
            },
            "rep_percentage": 95.2
          },
          "January": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "February": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "March": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "April": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "June": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "July": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "August": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "September": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "October": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "November": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          },
          "December": {
            "Questions": {
              "Review customer  Potentiality / Adoption / Rx Habit": 0,
              "Set SMART call objectives": 0
            },
            "rep_percentage": 0
          }
        },
      }
    },
  ],
  "normal_calls %": {
    "avg": {
      "Jan": 0,
      "Feb": 0,
      "Mar": 0,
      "Apr": 0,
      "May": 0,
      "Jun": 66.7,
      "Jul": 0,
      "Aug": 0,
      "Sep": 0,
      "Oct": 0,
      "Nov": 0,
      "Dec": 0
    },
  },
  "average_rep_percentages": {
    "avg": {
      "Jan": 0,
      "Feb": 0,
      "Mar": 0,
      "Apr": 0,
      "May": 0,
      "Jun": 96,
      "Jul": 0,
      "Aug": 0,
      "Sep": 0,
      "Oct": 0,
      "Nov": 0,
      "Dec": 0
    },
  }
};

final avg = {
  "973": {"April": 0, "May": 73, "June": 0},
  "974": {"April": 0, "May": 70.4, "June": 0},
  "975": {"April": 0, "May": 88.2, "June": 0},
  "976": {"April": 0, "May": 100, "June": 0}
};
final data = [
  {
    "category": "Personal Attributes",
    "reps": {
      "973": {
        "Apr": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "May": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "Jun": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        }
      },
      "974": {
        "Apr": {
          "Questions": {"Punctuality": 0, "Dress code": 0},
          "rep_percentage": 0
        },
        "May": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "Jun": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        }
      },
      "975": {
        "Apr": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "May": {
          "Questions": {"Punctuality": 100, "Dress code": 93.8},
          "rep_percentage": 75
        },
        "Jun": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        }
      },
      "976": {
        "Apr": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "May": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "Jun": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        }
      }
    }
  },
  {
    "category": "Pharmacy Feedback",
    "reps": {
      "973": {
        "Apr": {
          "Questions": {"Rate/Stock our Brands Vs Rate/Stock Competitors": 0},
          "rep_percentage": 0
        },
        "May": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "Jun": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        }
      },
      "974": {
        "Apr": {
          "Questions": {"Rate/Stock our Brands Vs Rate/Stock Competitors": 0},
          "rep_percentage": 0
        },
        "May": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "Jun": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        }
      },
      "975": {
        "Apr": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "May": {
          "Questions": {
            "Rate / Stock our Brands Vs Rate / Stock Competitors": 100
          },
          "rep_percentage": 100
        },
        "Jun": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        }
      },
      "976": {
        "Apr": {
          "Questions": {
            "Rate / Stock our Brands Vs Rate / Stock Competitors": 100
          },
          "rep_percentage": 100
        },
        "May": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        },
        "Jun": {
          "Questions": {"Punctuality": 100, "Dress code": 100},
          "rep_percentage": 100
        }
      }
    }
  }
];

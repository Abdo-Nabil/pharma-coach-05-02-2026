import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/data/models/getLocations/get_get_locations_resp.dart';
import 'package:mina_s_application5/data/models/loginUser/post_login_user_resp.dart';
import 'package:mina_s_application5/general_data.dart';
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

  var url = "http://37.61.217.36:8090/Pharcoo-master/public/index.php/api/v1";

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

  Future<int?> createVisit(
      int repId, int locationId, String visitTime, String shift) async {
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
          models.add(RepAnalysisModel.fromMap(response.data["data"][i],
              response.data["average_rep_percentages"]));
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
}

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

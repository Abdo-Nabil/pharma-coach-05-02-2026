import 'package:dio/dio.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/data/models/getLocations/get_get_locations_resp.dart';
import 'package:mina_s_application5/data/models/loginUser/post_login_user_resp.dart';

import 'network_interceptor.dart';

class ApiClient {
  factory ApiClient() {
    return _apiClient;
  }

  ApiClient._internal();

  var url = "http://37.61.217.36:8090/Pharcoo-master/public/index.php/api/v1";

  static final ApiClient _apiClient = ApiClient._internal();

  final _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
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
    ProgressDialogUtils.showProgressDialog();
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
  Future<PostLoginUserResp> loginUser(  String us , String pass,
      {
    Map<String, String> headers = const {'Content-Type': 'application/json',
      'Accept':'Accept'},
    Map requestData = const {},
  }) async {
    ProgressDialogUtils.showProgressDialog();
    try {
      await isNetworkConnected();
      var response = await _dio.post(
        '$url/login?email=$us@pharcoo.com&password=$pass',
       // data: requestData,

        options: Options(headers: headers),
      );
      ProgressDialogUtils.hideProgressDialog();
      if (_isSuccessCall(response)) {
        NavigatorService.popAndPushNamed(
          AppRoutes.homeContainerScreen,
        );

        return PostLoginUserResp.fromJson(response.data);
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
}

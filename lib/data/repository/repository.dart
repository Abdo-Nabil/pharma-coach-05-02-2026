import 'package:mina_s_application5/data/models/getLocations/get_get_locations_resp.dart';
import 'package:mina_s_application5/data/models/loginUser/post_login_user_resp.dart';

import '../apiClient/api_client.dart';

/// Repository class for managing API requests.
///
/// This class provides a simplified interface for making the
/// API request using the [ApiClient] instance
class Repository {
  final _apiClient = ApiClient();

  Future<GetGetLocationsResp> getLocations({
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParams = const {},
  }) async {
    return await _apiClient.getLocations(
      headers: headers,
      queryParams: queryParams,
    );
  }

  Future<PostLoginUserResp> loginUser({
    Map<String, String> headers = const {},
    Map requestData = const {},
  }) async {
    return await _apiClient.loginUser( "","",
      headers: headers,
      requestData: requestData,
    );
  }
}

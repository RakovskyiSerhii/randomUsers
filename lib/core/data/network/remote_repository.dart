import 'package:dio/dio.dart';
import 'package:random_users/core/tools/Const.dart';

import 'api/api_provider.dart';
import 'models/UserListResponse.dart';
import 'models/base_response.dart';

class RemoteRepository {
  final _apiProvider = ApiProvider();

  static final RemoteRepository _instance =
  RemoteRepository._internal();

  factory RemoteRepository() {
    return _instance;
  }

  RemoteRepository._internal();

  Future<BaseResponse<UserListResponse>> getUsers() async {
    BaseResponse<UserListResponse> convertedResponse;

    try {
      final response = await _apiProvider.getUsers();
      int statusCode = response.statusCode ?? 0;
      if (statusCode == 0) {
        convertedResponse = BaseResponse(code: Const.NETWORK_CONNECTION);
      } else if (statusCode == 200) {
        convertedResponse = BaseResponse(code: statusCode, data: UserListResponse.fromJson(response.data));
      } else {
        convertedResponse = BaseResponse(code: statusCode);
        // BaseResponse.fromErrorJson(statusCode, response.data);
      }
    } on DioError {
      convertedResponse = BaseResponse(code: Const.NETWORK_CONNECTION);
    }

    return Future.value(convertedResponse);
  }
}
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';

class ApiProvider {
  static const PAGINATION_LIMIT = 15;
  static const CONNECT_TIMEOUT = 10000;
  static String userAgent = "";

  final Dio _dio = Dio();
  final Logger _logger = Logger("ApiProvider");
  static final ApiProvider _instance = ApiProvider._internal();
  static const BASE_URL = "https://randomuser.me/api/";

  ApiProvider._internal() {

    _setupDio();
    _setUpUserAgent();
  }

  factory ApiProvider() {
    return _instance;
  }

  Future<Response> getUsers({int userCount = 20}) {
    return _dio.get(BASE_URL + "?results=$userCount");
  }

  void _setupDio() {
    _dio.options.connectTimeout = CONNECT_TIMEOUT;
    _dio.options.receiveTimeout = CONNECT_TIMEOUT;
    _dio.interceptors..add(InterceptorsWrapper(onRequest: (options) async {
      return _handleDioRequest(options);
    }, onResponse: (Response response) async {
      return _handleDioResponse(response);
    }, onError: (DioError error) async {
      return error;
    }));
  }

  dynamic _handleDioRequest(RequestOptions options) async {
    _logger.info("--> ${options.method} ${options.path}");
    _logger.info("Content type: ${options.contentType}");
    _logger.info("data: ${options.data}");
    _logger.info("<-- END HTTP");

    options.headers["lang"] = "uk";
    options.headers["user-agent"] = userAgent;
    options.headers["accept"] = "application/json";
    print(options.headers);

    return options;
  }

  _setUpUserAgent() async {
    final packageInfo = await PackageInfo.fromPlatform();

    String appVersion = packageInfo.version;
    String platform = "Undefined";
    String platformVersion = "Undefined";
    String deviceModel = "Undefined";

    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      platform = "Android";
      platformVersion = androidInfo.version.release;
      deviceModel = androidInfo.manufacturer + " " + androidInfo.model;
    } else if (Platform.isIOS) {
      var iOSInfo = await DeviceInfoPlugin().iosInfo;
      platform = "iOS";
      deviceModel = iOSInfo.model;
      platformVersion = iOSInfo.systemVersion;
    }

    userAgent = "$platform:$platformVersion;version:$appVersion;$deviceModel";
  }

  dynamic _handleDioResponse(Response response) {
    int maxCharactersPerLine = 200;
    _logger.info(
        "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
    String responseAsString = response.data.toString();
    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        _logger.info(
            responseAsString.substring(i * maxCharactersPerLine, endingIndex));
      }
    } else {
      _logger.info(response.data);
    }
    _logger.info("<-- END HTTP");
  }

  // dynamic _handleDioError(DioError error) {
  //   if (error.response.statusCode == 419 ||
  //       error.response.statusCode == 401 ||
  //       error.response.statusCode == 403) {
  //     return _requestInterceptor.verify(error.response, _dio, _preferences);
  //   } else
  //     return error.response;
  // }
}
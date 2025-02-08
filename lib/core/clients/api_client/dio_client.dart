import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:chromo_digital/core/clients/interceptor/retry_interceptor.dart';
import 'package:chromo_digital/core/constants/app_const.dart';

@LazySingleton()
class APIClient {
  final Dio _dio = Dio();

  APIClient() {
    _dio.options = _baseOptions;
  }

  Dio dio({int maxRetries = 2}) => _dio
    ..interceptors.addAll([
      // LogInterceptor(requestBody: true, responseBody: true, logPrint: Log.o),
      RetryInterceptor(dio: Dio(_baseOptions), maxRetries: maxRetries),

      /// [SessionInterceptor] is used to handle session related stuffs
      /// like logout, etc.
    ]);

  /// new and base dio
  Dio baseDio() => Dio();

  BaseOptions get _baseOptions => BaseOptions(
        headers: {HttpHeaders.contentTypeHeader: Headers.jsonContentType},
        sendTimeout: const Duration(milliseconds: AppConst.requestTimeoutMilliseconds),
        receiveTimeout: const Duration(milliseconds: AppConst.requestTimeoutMilliseconds),
        validateStatus: (status) => status! < 500,
        followRedirects: false,
      );
}

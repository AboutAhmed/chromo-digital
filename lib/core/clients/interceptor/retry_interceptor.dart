import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';

typedef RetryEvaluator = bool Function(DioException error);

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;

  /// if we need to pass custom condition to retry a request
  final RetryEvaluator? retryEvaluator;

  const RetryInterceptor({
    required this.dio,
    required this.maxRetries,
    this.retryInterval = const Duration(seconds: 2),
    this.retryEvaluator,
  });

  @override
  FutureOr<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    Log.e(runtimeType, err);
    var retries = 0;
    while (retries < maxRetries) {
      if (_shouldRetry(err)) {
        await Future.delayed(retryInterval);
        Log.i(runtimeType, 'Retrying count $retries');
        retries++;
        try {
          Map<String, String>? data = Map.fromEntries(err.requestOptions.data?.fields);
          var response = await dio.request(
            err.requestOptions.path,
            data: FormData.fromMap(data),
            queryParameters: err.requestOptions.queryParameters,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
          );
          handler.resolve(response);
        } catch (e) {
          debugPrint('RetryInterceptor.onError: $e');

          /// ignore exception if is there is connection error or any error in try bloc
        }
      } else {
        break;
      }
    }

    // If all retries failed, pass the error to the next handler
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (retryEvaluator?.call(err) ?? false);
  }
}

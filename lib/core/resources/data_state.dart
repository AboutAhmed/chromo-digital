import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/error/failure.dart';

abstract class DataState<T> {
  final T? data;
  final Failure? failure;

  const DataState({this.data, this.failure});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(Failure failure) : super(failure: failure);

  DataFailed.unknown({String? message, StackTrace? s})
      : super(
          failure: UnknownFailure(
            message: message ?? AppStrings.somethingWentWrong,
            stackTrace: s,
          ),
        );
}

extension DataStateX<T> on DataState<T> {
  bool get isSuccess => this is DataSuccess<T>;

  bool get isFailed => this is DataFailed<T>;

  DataSuccess<T> get asSuccess => this as DataSuccess<T>;

  DataFailed<T> get asFailed => this as DataFailed<T>;

  T? get data => isSuccess ? asSuccess.data : null;

  Failure? get failure => isFailed ? asFailed.failure : null;

  /// handle with when
  void when({
    required void Function(T data) success,
    void Function(Failure result)? onError,
    void Function(DatabaseFailure result)? onDatabaseError,
    void Function(APIFailure result)? onAPIError,
    void Function(UnknownFailure result)? onUnknownError,
  }) {
    if (isSuccess) {
      return success(asSuccess.data as T);
    } else if (isFailed) {
      onError?.call(asFailed.failure!);
      if (asFailed.failure! is DatabaseFailure) {
        return onDatabaseError?.call(asFailed.failure! as DatabaseFailure);
      }
      if (asFailed.failure! is APIFailure) {
        return onAPIError?.call(asFailed.failure! as APIFailure);
      }
      if (asFailed.failure! is UnknownFailure) {
        return onUnknownError?.call(asFailed.failure! as UnknownFailure);
      }
    }
  }
}

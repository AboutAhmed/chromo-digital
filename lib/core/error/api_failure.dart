part of 'failure.dart';

class APIFailure extends Failure {
  final int statusCode;

  const APIFailure({
    required this.statusCode,
    required super.message,
    super.stackTrace,
  });

  @override
  List<Object> get props => [statusCode, message];
}

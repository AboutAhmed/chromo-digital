part of 'failure.dart';

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.stackTrace});

  @override
  List<Object> get props => [message];
}

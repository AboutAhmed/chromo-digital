part of 'failure.dart';

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.stackTrace});

  @override
  List<Object> get props => [message];
}

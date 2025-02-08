import 'package:chromo_digital/core/error/failure.dart';

class GenericFailure extends Failure {
  const GenericFailure({required super.message, super.stackTrace});

  @override
  List<Object> get props => [message];
}

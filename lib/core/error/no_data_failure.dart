part of 'failure.dart';

class NoDataFailure extends Failure {
  const NoDataFailure({required super.message});

  @override
  List<Object> get props => [message];
}

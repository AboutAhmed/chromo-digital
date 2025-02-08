import 'package:equatable/equatable.dart';

part 'api_failure.dart';
part 'database_failure.dart';
part 'no_data_failure.dart';
part 'unknown_failure.dart';

abstract class Failure extends Equatable {
  final String message;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, stackTrace];
}

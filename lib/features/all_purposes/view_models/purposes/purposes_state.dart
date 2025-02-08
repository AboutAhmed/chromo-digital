part of 'purposes_cubit.dart';

@immutable
sealed class PurposesState {
  final List<Purpose> items;
  final Status status;
  final String? message;

  const PurposesState({
    this.items = const [],
    this.status = Status.initial,
    this.message,
  });

  PurposesState copyWith({
    List<Purpose>? items,
    Status? status,
    String? message,
  });
}

final class PurposesUpdate extends PurposesState {
  const PurposesUpdate({
    super.items = const [],
    super.status = Status.initial,
    super.message,
  });

  @override
  PurposesState copyWith({
    List<Purpose>? items,
    Status? status,
    String? message,
  }) {
    return PurposesUpdate(
      items: items ?? this.items,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

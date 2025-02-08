part of 'participants_cubit.dart';

@immutable
sealed class ParticipantsState {
  final List<Participant> items;
  final Status status;
  final String? message;

  const ParticipantsState({
    this.items = const [],
    this.status = Status.initial,
    this.message,
  });

  ParticipantsState copyWith({
    List<Participant>? items,
    Status? status,
    String? message,
  });
}

final class ParticipantsUpdate extends ParticipantsState {
  const ParticipantsUpdate({
    super.items = const [],
    super.status = Status.initial,
    super.message,
  });

  @override
  ParticipantsState copyWith({
    List<Participant>? items,
    Status? status,
    String? message,
  }) {
    return ParticipantsUpdate(
      items: items ?? this.items,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

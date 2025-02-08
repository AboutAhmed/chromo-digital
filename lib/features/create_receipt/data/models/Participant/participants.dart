import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participants.g.dart';

@JsonSerializable()
class Participant extends Equatable {
  final int id;
  final String name;
  final DateTime createdAt;

  Participant({
    final int? id,
    this.name = '',
    final DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        createdAt = createdAt ?? DateTime.now();

  Participant copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);

  @override
  List<Object?> get props => [id];
}

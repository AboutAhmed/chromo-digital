import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'purpose.g.dart';

@JsonSerializable()
class Purpose extends Equatable {
  final int id;
  final String value;
  final DateTime createdAt;

  Purpose({
    final int? id,
    this.value = '',
    final DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        createdAt = createdAt ?? DateTime.now();

  Purpose copyWith({
    int? id,
    String? value,
    DateTime? createdAt,
  }) {
    return Purpose(
      id: id ?? this.id,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Purpose.fromJson(Map<String, dynamic> json) => _$PurposeFromJson(json);

  Map<String, dynamic> toJson() => _$PurposeToJson(this);

  @override
  List<Object?> get props => [id];
}

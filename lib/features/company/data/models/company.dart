import 'package:chromo_digital/core/convertors/bool_to_int_convertor.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company extends Equatable {
  final int id;
  final String name;
  final String street;
  final String houseNumber;
  final String postId;
  final String city;
  final DateTime createdAt;
  @BoolToIntConvertor()
  final bool showOnReceipt;

  const Company({
    required this.id,
    required this.name,
    required this.street,
    required this.houseNumber,
    required this.postId,
    required this.city,
    required this.createdAt,
    this.showOnReceipt = false,
  });

  factory Company.empty() {
    return Company(
      id: -1,
      name: 'Chromo Digital',
      street: 'Street 1',
      houseNumber: '23',
      postId: '54',
      city: 'Lahore',
      createdAt: DateTime.now(),
      showOnReceipt: false,
    );
  }

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  @override
  List<Object?> get props => [id, name, street, houseNumber, postId, city, createdAt, showOnReceipt];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant extends Equatable {
  final int id;
  final String name;
  final String address;
  final int zipCode;
  final String city;

  Restaurant({
    final int? id,
    this.name = '',
    this.address = '',
    this.zipCode = -1,
    this.city = '',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  // copy with
  Restaurant copyWith({
    int? id,
    String? name,
    String? address,
    int? zipCode,
    String? city,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
    );
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  @override
  List<Object?> get props => [id];
}

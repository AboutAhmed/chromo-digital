import 'package:json_annotation/json_annotation.dart';

part 'restaurant_bill.g.dart';

@JsonSerializable()
class RestaurantBill {
  final int? id;
  final double? amount;
  final double? tip;
  final String? selectedDate;
  final String? managingDirectorSignaturePath;
  final String? waiterSignaturePath;

  RestaurantBill({
    this.id,
    this.amount,
    this.tip,
    this.selectedDate,
    this.managingDirectorSignaturePath,
    this.waiterSignaturePath,
  });

  // copyWith method
  RestaurantBill copyWith({
    int? id,
    double? amount,
    double? tip,
    String? selectedDate,
    String? managingDirectorSignaturePath,
    String? waiterSignaturePath,
  }) {
    return RestaurantBill(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      tip: tip ?? this.tip,
      selectedDate: selectedDate ?? this.selectedDate,
      managingDirectorSignaturePath: managingDirectorSignaturePath ?? this.managingDirectorSignaturePath,
      waiterSignaturePath: waiterSignaturePath ?? this.waiterSignaturePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'tip': tip,
      'selectedDate': selectedDate,
      'managingDirectorSignaturePath': managingDirectorSignaturePath,
      'waiterSignaturePath': waiterSignaturePath,
    };
  }

  factory RestaurantBill.fromJson(Map<String, dynamic> json) =>
      _$RestaurantBillFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantBillToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'receipt.g.dart';

@JsonSerializable()
class Receipt {
  final int id;
  final String name;
  final String filePath;
  final DateTime createdAt;

  Receipt({
    final int? id,
    required this.name,
    required this.filePath,
    required this.createdAt,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  factory Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptToJson(this);
}

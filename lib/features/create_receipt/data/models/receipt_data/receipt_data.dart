import 'package:chromo_digital/features/create_receipt/data/models/Participant/participants.dart';
import 'package:chromo_digital/features/create_receipt/data/models/purpose/purpose.dart';
import 'package:chromo_digital/features/create_receipt/data/models/restaurant/restaurant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'receipt_data.g.dart';

@JsonSerializable()
class ReceiptData {
  final Restaurant restaurant;
  final List<Participant> participants;
  final Purpose purpose;
  final List<String> images;
  final String? notes;
  final DateTime visitDate;
  final String billAmount;
  final String? tipAmount;
  final String? waiterSignaturePath;
  final String managingDirectorSignaturePath;

  const ReceiptData({
    required this.restaurant,
    required this.participants,
    required this.purpose,
    this.images = const [],
    this.notes,
    required this.visitDate,
    required this.billAmount,
    this.tipAmount,
    this.waiterSignaturePath,
    required this.managingDirectorSignaturePath,
  });

  // dummy data model
  static ReceiptData get data => ReceiptData(
        restaurant: Restaurant(
          name: 'Restaurant Name',
          address: 'Restaurant Address',
          city: 'Restaurant City',
          zipCode: 12345,
          id: 1,
        ),
        participants: [
          Participant(name: 'Participant Name', id: 1),
          Participant(name: 'Participant Name', id: 1),
          Participant(name: 'Participant Name', id: 1),
          Participant(name: 'Participant Name', id: 1),
          Participant(name: 'Participant Name', id: 1),
        ],
        purpose: Purpose(
          value: 'Purpose',
          id: 1,
        ),
        notes: '',
        visitDate: DateTime.now(),
        billAmount: '100',
        tipAmount: '10',
        managingDirectorSignaturePath: 'path/to/managing/director/signature',
        waiterSignaturePath: 'path/to/waiter/signature',
      );

  factory ReceiptData.fromJson(Map<String, dynamic> json) => _$ReceiptDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptDataToJson(this);
}

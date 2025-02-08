import 'dart:io';

import 'package:chromo_digital/features/create_receipt/data/models/Participant/participants.dart';
import 'package:chromo_digital/features/create_receipt/data/models/purpose/purpose.dart';
import 'package:chromo_digital/features/create_receipt/data/models/receipt_data/receipt_data.dart';
import 'package:chromo_digital/features/create_receipt/data/models/restaurant/restaurant.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_cubit.dart';

abstract class ReceiptState {
  final FormData<Restaurant>? restaurant;
  final List<FormData<Participant>> participants;
  final FormData<Purpose>? purpose;
  final List<File> images;
  final String? notes;
  final DateTime? visitDate;
  final String? billAmount;
  final String? tipAmount;
  final String? managingDirectorSignaturePath;
  final String? waiterSignaturePath;

  ReceiptState(
      {this.restaurant,
      this.participants = const [],
      this.purpose,
      this.images = const [],
      this.notes,
      this.visitDate,
      this.billAmount,
      this.tipAmount,
      this.managingDirectorSignaturePath,
      this.waiterSignaturePath});

  // copy with
  ReceiptState copyWith({
    FormData<Restaurant>? restaurant,
    List<FormData<Participant>>? participants,
    FormData<Purpose>? purpose,
    List<File>? images,
    String? notes,
    DateTime? visitDate,
    String? billAmount,
    String? tipAmount,
    String? managingDirectorSignaturePath,
    String? waiterSignaturePath,
  });
}

class ReceiptStateUpdate extends ReceiptState {
  ReceiptStateUpdate({
    super.restaurant,
    super.participants,
    super.purpose,
    super.images,
    super.notes,
    super.visitDate,
    super.billAmount,
    super.tipAmount,
    super.managingDirectorSignaturePath,
    super.waiterSignaturePath,
  });

  @override
  ReceiptStateUpdate copyWith({
    FormData<Restaurant>? restaurant,
    List<FormData<Participant>>? participants,
    FormData<Purpose>? purpose,
    List<File>? images,
    String? notes,
    DateTime? visitDate,
    String? billAmount,
    String? tipAmount,
    String? managingDirectorSignaturePath,
    String? waiterSignaturePath,
  }) {
    return ReceiptStateUpdate(
      restaurant: restaurant ?? this.restaurant,
      participants: participants ?? this.participants,
      purpose: purpose ?? this.purpose,
      images: images ?? this.images,
      notes: notes ?? this.notes,
      visitDate: visitDate ?? this.visitDate,
      billAmount: billAmount ?? this.billAmount,
      tipAmount: tipAmount ?? this.tipAmount,
      managingDirectorSignaturePath: managingDirectorSignaturePath ?? this.managingDirectorSignaturePath,
      waiterSignaturePath: waiterSignaturePath ?? this.waiterSignaturePath,
    );
  }
}

extension FormDataExtension<T> on ReceiptState {
  ReceiptData toReceiptData() {
    return ReceiptData(
      restaurant: restaurant?.data ?? Restaurant(),
      participants: participants.map((e) => e.data as Participant).toList(),
      purpose: purpose!.data!,
      images: images.map((e) => e.path).toList(),
      notes: notes,
      visitDate: visitDate!,
      billAmount: billAmount!,
      tipAmount: tipAmount,
      waiterSignaturePath: waiterSignaturePath,
      managingDirectorSignaturePath: managingDirectorSignaturePath!,
    );
  }
}

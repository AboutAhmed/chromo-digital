import 'dart:core';
import 'dart:io';

import 'package:chromo_digital/features/create_receipt/data/models/Participant/participants.dart';
import 'package:chromo_digital/features/create_receipt/data/models/purpose/purpose.dart';
import 'package:chromo_digital/features/create_receipt/data/models/restaurant/restaurant.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_state.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

enum EntryType { newEntry, saved, dbEntry }

@LazySingleton()
class ReceiptCubit extends Cubit<ReceiptState> {
  ReceiptCubit() : super(ReceiptStateUpdate());

  void onRestaurantChanged(FormData<Restaurant>? item) => emit(state.copyWith(restaurant: item));

  void onParticipantsAdd(List<FormData<Participant>> items) {
    final updatedParticipants = List<FormData<Participant>>.from(state.participants);
    updatedParticipants.addAll(items);
    List<FormData<Participant>> distList = updatedParticipants.distinctBy((d) => d.data?.id).toList();
    emit(state.copyWith(participants: distList));
  }

  void onParticipantsRemove(FormData<Participant> item) {
    final updatedParticipants = List<FormData<Participant>>.from(state.participants);
    updatedParticipants.remove(item);
    emit(state.copyWith(participants: updatedParticipants));
  }

  // update all participants
  void onParticipantsChanged(List<FormData<Participant>> items) => emit(state.copyWith(participants: [...items]));

  void onPurposeChanged(FormData<Purpose>? item) => emit(state.copyWith(purpose: item));

  void addNotes(String value) => emit(state.copyWith(notes: value));

  void addBillAmount(String value) => emit(state.copyWith(billAmount: value));

  void addTipAmount(String value) => emit(state.copyWith(tipAmount: value));

  void addVisitDate(DateTime value) => emit(state.copyWith(visitDate: value));

  void addWaiterSignature(String value) => emit(state.copyWith(waiterSignaturePath: value));

  void clearWaiterSignature() => emit(state.copyWith(waiterSignaturePath: ''));

  void addManagingDirectorSignature(String value) => emit(state.copyWith(managingDirectorSignaturePath: value));

  void addImages(List<File> value) => emit(state.copyWith(images: value));

  void reset() => emit(ReceiptStateUpdate());
}

final class FormData<T> {
  final T? data;
  final EntryType type;

  const FormData({
    required this.data,
    required this.type,
  });

  FormData.db({required this.data}) : type = EntryType.dbEntry;

  FormData.saved({required this.data}) : type = EntryType.saved;

  FormData.newEntry({required this.data}) : type = EntryType.newEntry;

  FormData.empty()
      : data = null,
        type = EntryType.newEntry;

  // copy with
  FormData<T> copyWith({
    T? data,
    EntryType? type,
  }) {
    return FormData<T>(
      data: data ?? this.data,
      type: type ?? this.type,
    );
  }
}

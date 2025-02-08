import 'package:chromo_digital/core/enums/status.dart';
import 'package:chromo_digital/core/error/failure.dart';
import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/features/create_receipt/data/models/Participant/participants.dart';
import 'package:chromo_digital/features/create_receipt/repositories/participant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'participants_state.dart';

@LazySingleton()
class ParticipantsCubit extends Cubit<ParticipantsState> {
  final ParticipantsRepository _repository;

  ParticipantsCubit(this._repository) : super(ParticipantsUpdate());

  /// Fetch all participants from the repository
  Future<void> getAllParticipants() async {
    emit(state.copyWith(status: Status.loading));
    DataState<List<Participant>> result = await _repository.getAllParticipants();
    result.when(
      success: (items) => emit(state.copyWith(items: items, status: Status.loaded)),
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }

  /// Save a participant and update the state
  Future<void> saveAParticipants(List<Participant> items) async {
    List<Participant> oldItems = [...state.items];
    emit(state.copyWith(status: Status.loading));
    DataState<List<int>> result = await _repository.saveParticipants(items);
    result.when(
      success: (_) => emit(state.copyWith(items: [...items, ...oldItems], status: Status.loaded)),
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error, items: oldItems)),
    );
  }

  Future<void> saveAParticipant(Participant item) async {
    List<Participant> oldItems = [...state.items];
    emit(state.copyWith(status: Status.loading));
    DataState<int> result = await _repository.saveParticipant(item);
    result.when(
      success: (_) => emit(state.copyWith(items: [item, ...oldItems], status: Status.loaded)),
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error, items: oldItems)),
    );
  }

  Future<void> updateParticipant(Participant item) async {
    List<Participant> oldItems = [...state.items];
    emit(state.copyWith(status: Status.loading));
    DataState<int> result = await _repository.updateParticipant(item);
    result.when(
      success: (int value) {
        List<Participant> newItems = oldItems.map((e) => e.id == item.id ? item : e).toList();
        emit(state.copyWith(items: newItems, status: Status.loaded));
      },
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }

  // delete
  void deleteParticipant(int id) async {
    DataState<int> result = await _repository.deleteParticipant(id);
    result.when(
      success: (int value) {
        if (value > 0) {
          List<Participant> newItems = state.items.where((element) => element.id != id).toList();
          emit(state.copyWith(items: newItems, status: Status.loaded));
        } else {
          emit(state.copyWith(items: state.items, status: Status.loaded));
        }
      },
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }
}

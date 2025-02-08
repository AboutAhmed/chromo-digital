import 'package:chromo_digital/core/enums/status.dart';
import 'package:chromo_digital/core/error/failure.dart';
import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/features/create_receipt/data/models/purpose/purpose.dart';
import 'package:chromo_digital/features/create_receipt/repositories/purpose_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'purposes_state.dart';

@LazySingleton()
class PurposesCubit extends Cubit<PurposesState> {
  final PurposeRepository _repository;

  PurposesCubit(this._repository) : super(PurposesUpdate());

  Future<void> getAllPurposes() async {
    emit(state.copyWith(status: Status.loading));
    DataState<List<Purpose>> result = await _repository.getAllPurposes();
    result.when(
      success: (items) => emit(state.copyWith(items: items, status: Status.loaded)),
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }

  void savePurpose(Purpose item) async {
    emit(state.copyWith(status: Status.loading));
    List<Purpose> oldItems = [...state.items];
    DataState<int> result = await _repository.savePurpose(item);
    result.when(
      success: (_) => emit(state.copyWith(items: [item, ...oldItems], status: Status.loaded)),
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }

  void updatePurpose(Purpose item) async {
    List<Purpose> oldItems = [...state.items];
    emit(state.copyWith(status: Status.loading));
    DataState<int> result = await _repository.updatePurpose(item);
    result.when(
      success: (int value) {
        List<Purpose> newItems = oldItems.map((e) => e.id == item.id ? item : e).toList();
        emit(state.copyWith(items: newItems, status: Status.loaded));
      },
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }

  void deletePurpose(int id) async {
    DataState<int> result = await _repository.deletePurpose(id);
    result.when(
      success: (int value) {
        if (value > 0) {
          var newItems = state.items.where((element) => element.id != id).toList();
          emit(state.copyWith(items: newItems, status: Status.loaded));
        } else {
          emit(state.copyWith(items: state.items, status: Status.loaded));
        }
      },
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }
}

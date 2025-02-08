import 'package:bloc_state_gen/bloc_state_gen.dart';
import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/features/create_receipt/data/models/receipt/receipt.dart';
import 'package:chromo_digital/features/create_receipt/repositories/receipts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'receipts_cubit.s.dart';
part 'receipts_state.dart';

@LazySingleton()
@BlocStateGen()
class ReceiptsCubit extends Cubit<ReceiptsState> {
  final ReceiptsRepository _repository;

  ReceiptsCubit(this._repository) : super(ReceiptsInitial());

  void getAllReceipts() async {
    emit(ReceiptsLoading());
    final result = await _repository.getAllReceipts();
    result.when(
      success: (items) => emit(ReceiptsLoaded(items)),
      onError: (failure) => emit(ReceiptsError(failure.message)),
    );
  }

  void saveReceipt(Receipt item) async {
    final result = await _repository.saveReceipt(item);
    result.when(
      success: (value) {
        if (value > 0) {
          if (state is ReceiptsLoaded) {
            emit(ReceiptsLoaded((state as ReceiptsLoaded).items..insert(0, item)));
          } else {
            emit(ReceiptsLoaded([item]));
          }
        }
      },
      onError: (failure) => emit(ReceiptsError(failure.message)),
    );
  }

  Future<void> deleteReceipt(int receiptId) async {
    final result = await _repository.deleteReceipt(receiptId);
    result.when(
      success: (_) {
        if (state is ReceiptsLoaded) {
          final updatedItems = List<Receipt>.from((state as ReceiptsLoaded).items)..removeWhere((item) => item.id == receiptId);
          emit(ReceiptsLoaded(updatedItems));
        }
      },
      onError: (failure) => emit(ReceiptsError(failure.message)),
    );
  }
}

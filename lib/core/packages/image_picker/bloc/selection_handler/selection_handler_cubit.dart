import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chromo_digital/core/packages/image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

part 'selection_handler_state.dart';

@Injectable()
class SelectionHandlerCubit extends Cubit<SelectionHandlerState> {
  SelectionHandlerCubit() : super(const SelectionHandlerUpdate());

  void init({
    required List<File> items,
    required bool multiSelection,
    required int maxItemsLimit,
  }) {
    emit(SelectionHandlerUpdate(
      items: [...items],
      multiSelection: multiSelection,
      maxItemsLimit: maxItemsLimit,
    ));
  }

  Future<void> addEntity(AssetEntity asset) async {
    File? file = await asset.file;
    if (file == null) return;

    // multi-selection = false
    if (!state.multiSelection) {
      emit(state.copyWith(items: [file]));
      return;
    }
    // if item is not added then add else remove it
    // multi-selection = true
    // check max limit as well
    if (state.items.any((f) => f.path == file.path)) {
      List<File> items = state.items..removeWhere((f) => f.path == file.path);
      emit(state.copyWith(items: [...items]));
    } else if (state.items.length < state.maxItemsLimit) {
      emit(state.copyWith(items: state.items..add(file)));
    }
    emit(state.copyWith(limitReached: state.items.length == state.maxItemsLimit));
  }

  Future<void> addCameraFile(File file) async {
    // multi-selection = false
    if (!state.multiSelection) {
      emit(state.copyWith(items: [file]));
      return;
    }

    if (state.items.any((f) => f.path == file.path)) {
      List<File> items = state.items..removeWhere((f) => f.path == file.path);
      emit(state.copyWith(items: [...items]));
    } else if (state.items.length < state.maxItemsLimit) {
      emit(state.copyWith(items: state.items..add(file)));
    }

    emit(state.copyWith(limitReached: state.items.length == state.maxItemsLimit));
  }

  void delete(File file) {
    List<File> items = state.items..removeWhere((f) => f.path == file.path);
    emit(state.copyWith(items: [...items]));
  }
}

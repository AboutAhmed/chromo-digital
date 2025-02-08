import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:injectable/injectable.dart';

import '../data/models/locale_model.dart';
import '../data/repository/locals_repository.dart';

@LazySingleton()
class LocalizationsCubit extends Cubit<List<LocaleModel>> {
  final LocaleRepository _repository;

  LocalizationsCubit(this._repository) : super([]);

  Future<void> init() async {
    DataState dataState = await _repository.getLocales();
    if (dataState is DataSuccess) {
      emit(dataState.data);
    } else {
      Log.d(runtimeType, 'Something went wrong');
    }
  }
}

import 'dart:async';

import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/features/settings/localization/data/data_source/locales.dart';
import 'package:chromo_digital/features/settings/localization/data/models/locale_model.dart';
import 'package:chromo_digital/features/settings/localization/data/repository/locals_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LocaleRepository)
class LocaleRepositoryImpl implements LocaleRepository {
  final LocalesHolder _dataHolder;

  LocaleRepositoryImpl(this._dataHolder);

  @override
  FutureOr<DataState<List<LocaleModel>>> getLocales() {
    return DataSuccess(_dataHolder.getLocales);
  }
}

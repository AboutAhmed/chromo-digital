import 'dart:async';

import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/features/settings/localization/data/models/locale_model.dart';

abstract class LocaleRepository {
  FutureOr<DataState<List<LocaleModel>>> getLocales();
}

import 'package:chromo_digital/features/settings/localization/data/models/locale_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalesHolder {
  List<LocaleModel> get getLocales {
    return const [
      LocaleModel(label: 'English', locale: Locale('en', 'US')),
      LocaleModel(label: 'German', locale: Locale('de', 'DE')),
    ];
  }
}

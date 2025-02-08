import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:chromo_digital/features/settings/theme/data/data_sources/themes.dart';
import 'package:chromo_digital/features/settings/theme/data/models/theme_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ThemeCubit extends HydratedCubit<ThemeModel> {
  /// default theme is light theme
  ThemeCubit() : super(AppThemeData.defaultTheme);

  void changeTheme(ThemeModel theme) => emit(theme);

  @override
  ThemeModel? fromJson(Map<String, dynamic> json) {
    return AppThemeData.getThemeByMode(ThemeMode.values[json['theme'] ?? 0]);
  }

  @override
  Map<String, dynamic>? toJson(ThemeModel state) => {'theme': state.themeMode.index};
}

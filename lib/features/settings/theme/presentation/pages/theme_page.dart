import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/card/my_card.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/features/settings/theme/data/data_sources/themes.dart';
import 'package:chromo_digital/features/settings/theme/data/models/theme_model.dart';
import 'package:chromo_digital/features/settings/theme/presentation/bloc/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeCubit themeCubit = sl<ThemeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(AppStrings.dark)),
      ),
      body: MyCard.outline(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            AppThemeData.themes.length,
            (index) {
              return BlocBuilder<ThemeCubit, ThemeModel>(
                bloc: themeCubit,
                builder: (context, _) {
                  final ThemeModel theme = AppThemeData.themes[index];
                  return ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    trailing: themeCubit.state.themeMode == theme.themeMode ? const Icon(Icons.check) : null,
                    onTap: () => themeCubit.changeTheme(theme),
                    title: Text(context.tr(theme.name)),
                    subtitle: theme.description != null ? Text(context.tr(theme.description!)) : null,
                  );
                },
              );
            },
          ),
        ),
      ).responsiveConstrains(),
    );
  }
}

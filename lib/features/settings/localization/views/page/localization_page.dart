import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/card/my_card.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/features/settings/localization/bloc/localizations_cubit.dart';
import 'package:chromo_digital/features/settings/localization/data/models/locale_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LocalizationPage extends StatelessWidget {
  LocalizationPage({super.key});

  final LocalizationsCubit _localizationCubit = sl<LocalizationsCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(AppStrings.language))),
      body: BlocBuilder<LocalizationsCubit, List<LocaleModel>>(
          bloc: _localizationCubit,
          builder: (context, items) {
            return ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (_, index) {
                LocaleModel localeItem = items[index];
                return MyCard.outline(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  borderRadius: BorderRadius.circular(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    trailing: context.locale == localeItem.locale ? const Icon(Icons.check) : null,
                    onTap: () => context.setLocale(localeItem.locale),
                    tileColor: context.cardColor,
                    title: Text(context.tr(localeItem.label)),
                  ),
                );
              },
            ).responsiveConstrains();
          }),
    );
  }
}

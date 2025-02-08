import 'package:chromo_digital/config/routes/routes.dart';
import 'package:chromo_digital/config/theme/theme_dark.dart';
import 'package:chromo_digital/config/theme/theme_light.dart';
import 'package:chromo_digital/core/bloc/app_multi_bloc_provider.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:chromo_digital/features/settings/theme/data/models/theme_model.dart';
import 'package:chromo_digital/features/settings/theme/presentation/bloc/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final AppRouter appRouter = AppRouter();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.setLocale(Locale('de', 'DE'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.unfocus,
      child: BlocBuilder<ThemeCubit, ThemeModel>(
        bloc: sl<ThemeCubit>(),
        builder: (context, theme) {
          return AppMultiBlocProvider(
            child: MaterialApp.router(
              key: navigatorKey,
              themeMode: ThemeMode.dark,
              debugShowCheckedModeBanner: false,

              /// locale by easy localization
              locale: context.locale,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,

              title: 'welcome',
              theme: ThemeLight().themeData,
              darkTheme: ThemeDark().themeData,
              routerConfig: appRouter.config(navigatorObservers: () => [AppRouteObserver()]),
            ),
          );
        },
      ),
    );
  }
}

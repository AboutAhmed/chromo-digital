import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/services/services/package_info/package_info_service.dart';
import 'package:chromo_digital/features/settings/settings/view/widgets/setting_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage(name: 'SettingsEmptyRoute')
class SettingsRouterEmptyRoute extends AutoRouter {
  const SettingsRouterEmptyRoute({super.key});
}

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pkgInfo = sl<PackageInfoService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(AppStrings.settings)),
        leading: IconButton(onPressed: context.maybePop, icon: Icon(LucideIcons.chevronLeft)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12.0,
          children: [
            SettingTile(
              title: context.tr(AppStrings.language),
              leading: Icon(LucideIcons.languages, color: context.primary),
              onTap: () => context.pushRoute(LocalizationRoute()),
            ),
            const SizedBox(height: 48.0),
            Text(
              'Version: ${pkgInfo.version}+${pkgInfo.buildNumber}',
              style: context.bodySmall!,
            ).center(),
          ],
        ).responsiveConstrains(),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}

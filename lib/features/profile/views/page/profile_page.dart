import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/features/company/data/models/company.dart';
import 'package:chromo_digital/features/company/view_models/company/company_cubit.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_cubit.dart';
import 'package:chromo_digital/features/profile/views/widgets/company_tile.dart';
import 'package:chromo_digital/features/settings/settings/view/widgets/setting_tile.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formData = sl<ReceiptCubit>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.yourProfile, style: context.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.settings),
            onPressed: () => context.pushRoute(SettingsRoute()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            BlocSelector<CompanyCubit, CompanyState, Company>(
              bloc: sl<CompanyCubit>(),
              selector: (state) => state.matchSome(
                orElse: () => Company.empty(),
                onCompanyLoaded: (company) => company,
              ),
              builder: (context, item) => CompanyTile(item: item),
            ),
            SizedBox(height: 20),
            Text(
              AppStrings.savedItems,
              style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20.0),
            SettingTile(
              leading: Icon(LucideIcons.store),
              title: AppStrings.restaurants,
              trailing: Icon(LucideIcons.chevronRight, color: context.primary),
              onTap: () => context.pushRoute(AllRestaurantsRoute()),
            ),
            Divider(),
            SettingTile(
              leading: Icon(LucideIcons.briefcaseBusiness),
              title: AppStrings.participants,
              onTap: () => context.pushRoute(AllParticipantsRoute()),
              trailing: Icon(LucideIcons.chevronRight, color: context.primary),
            ),
            Divider(),
            SettingTile(
              leading: Icon(LucideIcons.clipboardPenLine),
              title: AppStrings.purposes,
              onTap: () => context.pushRoute(AllPurposesRoute()),
              trailing: Icon(LucideIcons.chevronRight, color: context.primary),
            ),
          ],
        ),
      ),
    );
  }
}

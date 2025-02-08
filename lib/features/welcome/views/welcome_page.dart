import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/widgets/app_image.dart';
import 'package:chromo_digital/features/company/view_models/company/company_cubit.dart';
import 'package:chromo_digital/gen/assets.gen.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final CompanyCubit _companyCubit = sl<CompanyCubit>();

  @override
  void initState() {
    super.initState();
    // sl<ReceiptGeneratorCubit>()
    //   ..generateReceipt(context, ReceiptData.data, Company.empty())
    //   ..stream.listen((state) {
    //     if (state is ReceiptGenerated) {
    //       _saveAndViewReceipt(state.file, state.data);
    //     }
    //   });
    _companyCubit.getCompany();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyCubit, CompanyState>(
      bloc: _companyCubit,
      listener: (context, state) {
        if (state is CompanyLoaded) {
          context.router.replaceAll([DashboardRoute()]);
        } else {
          context.router.replaceAll([CompanyUpdateRoute()]);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage.asset(Assets.images.appLogo.path, height: 100.0),
              const SizedBox(height: 20.0),
              const Text('Welcome to ${AppStrings.appName}!'),
            ],
          ).center(),
        );
      },
    );
  }

// void _saveAndViewReceipt(File file, ReceiptData data) {
//   Receipt item = Receipt(
//     id: DateTime.now().millisecondsSinceEpoch,
//     name: data.restaurant.name,
//     createdAt: DateTime.now(),
//     filePath: file.path,
//   );
//   context.pushRoute(ReceiptViewerRoute(filePath: file.path));
// }
}

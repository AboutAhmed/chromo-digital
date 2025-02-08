import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
          children: [
            Text(AppStrings.welcome, style: context.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12.0),
            AppButton(
              onPressed: () => context.pushRoute(CreateReceiptRoute()),
              width: context.width * 0.8,
              child: Text(AppStrings.addNewReceipt),
            ),
            AppButton(
              onPressed: () => context.pushRoute(ReceiptsRoute()),
              width: context.width * 0.8,
              child: Text(AppStrings.viewCreatedReceipts),
            ),
          ],
        ),
      ),
    );
  }
}

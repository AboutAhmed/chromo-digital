import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';

class DeleteReceiptConfirmation extends StatelessWidget {
  const DeleteReceiptConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.0,
        children: [
          Text(AppStrings.areYouSureYouWantToDeleteThisReceipt, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(
            spacing: 12,
            children: [
              AppButton.outline(
                onPressed: context.maybePop,
                child: Text(AppStrings.cancel),
              ).expanded(),
              AppButton(
                onPressed: () => context.maybePop(true),
                child: Text(AppStrings.delete),
              ).expanded(),
            ],
          ).paddingAll(12.0),
        ],
      ),
    );
  }
}

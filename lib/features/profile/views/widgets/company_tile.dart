import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/features/company/data/models/company.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CompanyTile extends StatelessWidget {
  final Company item;

  const CompanyTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item == Company.empty()) {
      return AppButton.outlineShrink(
        child: Text(AppStrings.addCompanyData),
        onPressed: () => context.pushRoute(CompanyUpdateRoute()),
      );
    }

    return GestureDetector(
      onTap: () => context.pushRoute(CompanyUpdateRoute(item: item)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.onPrimary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.street}, ${item.houseNumber}, ${item.postId}, ${item.city}',
                  style: context.bodySmall!.copyWith(fontWeight: FontWeight.w600).small,
                ),
                const SizedBox(height: 8),
                // ShowOnReceipt Indicator
                Row(
                  children: [
                    Icon(
                      item.showOnReceipt ? Icons.receipt_long : Icons.receipt_outlined,
                      color: item.showOnReceipt ? context.primary : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.showOnReceipt ? "Shown on Receipt" : "Hidden from Receipt",
                      style: context.bodySmall!
                          .copyWith(
                            color: item.showOnReceipt ? context.primary : Colors.grey,
                            fontWeight: FontWeight.w500,
                          )
                          .small,
                    ),
                  ],
                ),
              ],
            ).expanded(),
            Icon(LucideIcons.pen, color: context.primary),
          ],
        ),
      ),
    );
  }
}

import 'package:chromo_digital/core/card/my_card.dart';
import 'package:chromo_digital/core/constants/app_const.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/features/create_receipt/data/models/purpose/purpose.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PurposeTile extends StatelessWidget {
  final Purpose item;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PurposeTile({
    super.key,
    required this.item,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return MyCard.outline(
      onTap: onTap,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon placeholder for participant
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(color: context.primaryContainer.withAlpha(25)),
            child: Center(child: Icon(LucideIcons.clipboardPenLine, color: context.onPrimary)),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.value.isNotEmpty ? item.value : AppStrings.noName,
                      style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).expanded(),
                    _ActionButton(
                      onPressed: onEdit,
                      icon: LucideIcons.pen,
                      backgroundColor: context.primaryContainer.withAlpha(25),
                      iconColor: context.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      onPressed: onDelete,
                      icon: LucideIcons.trash,
                      backgroundColor: context.errorContainer.withAlpha(25),
                      iconColor: context.onErrorContainer,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(LucideIcons.calendarDays, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      item.createdAt.format(format: AppConst.dateFormat),
                      style: context.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 36.0,
        width: 36.0,
        decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}

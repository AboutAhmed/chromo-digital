import 'package:chromo_digital/core/card/my_card.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final VoidCallback onTap;

  const SettingTile({
    super.key,
    required this.leading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MyCard.outline(
      onTap: onTap,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: context.primaryContainer.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Center(child: leading),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            color: context.primary,
          ),
        ],
      ),
    );
  }
}

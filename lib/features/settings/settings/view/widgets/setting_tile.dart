import 'package:chromo_digital/core/card/my_card.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final Color? color;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Widget? leading;
  final EdgeInsetsGeometry? padding;

  const SettingTile({
    super.key,
    required this.title,
    this.color,
    this.trailing,
    this.onTap,
    this.leading,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return MyCard.outline(
      onTap: onTap,
      height: 56.0,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 16.0),
            ],
            Expanded(
              child: Text(
                title,
                style: context.titleSmall!.copyWith(color: color),
              ),
            ),
            if (trailing != null) trailing! else Icon(Icons.chevron_right, color: context.primary),
          ],
        ),
      ),
    );
  }
}

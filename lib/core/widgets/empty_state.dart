import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/extensions/widget_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final Widget _child;

  EmptyState({
    super.key,
    final Widget? title,
    final Widget? subtitle,
    final Widget? icon,
    final Widget? child,
    final EdgeInsets? padding,
    List<Widget> actions = const [],
  }) : _child = _EmptyState(
          padding: padding,
          title: title,
          subtitle: subtitle,
          icon: icon,
          actions: actions,
          child: child,
        );

  EmptyState.fail({
    super.key,
    final Widget? title,
    final Widget? subtitle,
    final Widget? icon,
    final Widget? child,
    final Color? onSurface,
    final EdgeInsets? padding,
    final VoidCallback? onRetry,
    final Widget? action,
  }) : _child = _EmptyState(
          isErrorState: true,
          padding: padding,
          title: title,
          subtitle: subtitle,
          icon: icon,
          onRetry: onRetry,
          action: action,
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}

class _EmptyState extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? icon;
  final Widget? child;
  final bool isErrorState;
  final EdgeInsets padding;
  final VoidCallback? onRetry;
  final Widget? action;
  final List<Widget> actions;

  const _EmptyState({
    this.title,
    this.subtitle,
    this.icon,
    this.child,
    final EdgeInsets? padding,
    this.isErrorState = false,
    this.onRetry,
    this.action,
    final List<Widget>? actions,
  })  : padding = padding ?? EdgeInsets.zero,
        actions = actions ?? const [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (child != null) child!,
        if (icon != null)
          Theme(
            data: context.theme.copyWith(
              iconTheme: context.iconTheme.copyWith(size: 64.0, color: isErrorState ? context.error : null),
            ),
            child: icon!,
          ),
        if (title != null) DefaultTextStyle(style: context.titleMedium!, textAlign: TextAlign.center, child: title!),
        if (subtitle != null) DefaultTextStyle(style: context.bodyMedium!, textAlign: TextAlign.center, child: subtitle!),
        if (action != null) action!,
        if (onRetry != null)
          TextButton(
            onPressed: onRetry,
            child: Text(AppStrings.retry, style: context.titleSmall!.copyWith(color: context.primary)).tr(),
          ),
        if (actions.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: actions,
          ).childrenPadding(EdgeInsets.all(8.0)).fit(),
      ],
    ).childrenPadding(const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0)).padding(padding);
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';

class AppSearchBar extends StatelessWidget {
  final double? radius;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final String hint;
  final bool enabled;
  final bool filled;
  final Color fillColor;

  const AppSearchBar({
    this.onChanged,
    super.key,
    this.hint = AppStrings.search,
    this.radius,
    this.onSubmitted,
    this.enabled = true,
    this.filled = false,
    this.fillColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        onChanged: onChanged,
        enabled: enabled,
        onFieldSubmitted: onSubmitted,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: filled,
          fillColor: fillColor,
          prefixIcon: Icon(Icons.search_outlined) ,
          // AppImage.svg(
          //   Assets.svgs.searchNormal,
          //   color: const Color(0xffA1A1A1),
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 8.0,
          //     horizontal: 15.0,
          //   ),
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 24.0),
            borderSide: BorderSide(
              color: Colors.grey.withValues(alpha: 250 * 0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 24.0),
            borderSide: BorderSide(
              color: Colors.grey.withValues(alpha: 250 * 0.2),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 24.0),
            borderSide: BorderSide(
              color: Colors.grey.withValues(alpha: 250 * 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 24.0),
            borderSide: BorderSide(
              color: Colors.grey.withValues(alpha: 250 * 0.2),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          hintText: context.tr(hint),
          hintStyle: const TextStyle(height: 1.4, color: Color(0xffA1A1A1), fontSize: 13.0),
        ),
      ),
    );
  }
}

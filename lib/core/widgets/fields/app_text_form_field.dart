import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/bloc/helper.dart';
import 'package:chromo_digital/core/card/my_card.dart';
import 'package:chromo_digital/core/constants/app_const.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'date_text_form_field.dart';
part 'date_with_label_form_field.dart';
part 'dropdown_multi_selection_text_form_field.dart';
part 'dropdown_text_form_field.dart';
part 'time_picket_form_field.dart';

class AppTextFormField<T> extends StatelessWidget {
  final Widget _child;

  AppTextFormField.date({
    final DateTime? initialValue,
    final DateTime? initialDate,
    final DateTime? firstDate,
    final DateTime? lastDate,
    super.key,
    final String? hintText,
    final String? title,
    final void Function(DateTime)? onChanged,
    final TextInputAction? textInputAction,
    final String? Function(String? value)? validator,
    final Widget? prefixIcon,
    final bool? updatedBorders,
    final String? format,
  }) : _child = _AppTextFormFieldDate(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          hintText: hintText,
          title: title,
          initialValue: initialValue,
          onChanged: onChanged,
          textInputAction: textInputAction,
          prefixIcon: prefixIcon,
          validator: validator,
          updatedBorders: updatedBorders ?? false,
          format: format,
        );

  AppTextFormField({
    final String? initialValue,
    super.key,
    final String? hintText,
    final String? title,
    final void Function(String value)? onChanged,
    final TextInputAction? textInputAction,
    final String? Function(String? value)? validator,
    final Widget? prefixIcon,
    final Widget? suffixIcon,
    final VoidCallback? onTap,
    final bool? readOnly,
    final TextInputType? keyboardType,
    final List<TextInputFormatter>? inputFormatters,
    final TextEditingController? controller,
    final TextCapitalization? textCapitalization,
    final AutovalidateMode? autovalidateMode,
  }) : _child = _AppTextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          title: title,
          validator: validator,
          hintText: hintText,
          textInputAction: textInputAction,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          onTap: onTap,
          readOnly: readOnly ?? false,
          keyboardType: keyboardType ?? TextInputType.text,
          inputFormatters: inputFormatters,
          controller: controller,
          textCapitalization: textCapitalization,
          autovalidateMode: autovalidateMode,
        );

  AppTextFormField.dateWithLabel({
    final DateTime? initialValue,
    super.key,
    final String? labelText,
    final void Function(String)? onChanged,
    final TextInputAction? textInputAction,
    final String? Function(String? value)? validator,
    final Widget? prefixIcon,
    final BorderRadius? borderRadius,
  }) : _child = _DateWithLabelFormField(
          labelText: labelText,
          initialValue: initialValue,
          onChanged: onChanged,
          textInputAction: textInputAction,
          prefixIcon: prefixIcon,
          validator: validator,
          borderRadius: borderRadius,
        );

  AppTextFormField.time({
    final DateTime? initialValue,
    super.key,
    final String? hintText,
    final void Function(String, String)? onChanged,
    final TextInputAction? textInputAction,
    final String? Function(String? value)? validator,
    final Widget? prefixIcon,
  }) : _child = _AppTextFormFieldTime(
          hintText: hintText,
          initialValue: initialValue,
          onChanged: onChanged,
          textInputAction: textInputAction,
          prefixIcon: prefixIcon,
          validator: validator,
        );

  AppTextFormField.dropdown({
    final T? initialValue,
    super.key,
    required final List<DropdownData<T>> items,
    final void Function(T value)? onChanged,
    final Widget? prefixIcon,
    final String? hintText,
    final String? title,
    final String? labelText,
    final String? Function(String? value)? validator,
    final EdgeInsets? contentPadding,
    final TextStyle? itemStyle,
    final TextStyle? hintStyle,
    final TextStyle? style,
    final bool? updatedBorders,
  }) : _child = _DropDownTextFormField(
          initialValue: initialValue,
          items: items,
          onChanged: onChanged,
          prefixIcon: prefixIcon,
          hintText: hintText,
          labelText: labelText,
          validator: validator,
          contentPadding: contentPadding,
          hintStyle: hintStyle,
          itemStyle: itemStyle,
          style: style,
          updatedBorders: updatedBorders ?? false,
        );

  AppTextFormField.multiSelectionDropdown({
    super.key,
    required final List<DropdownData<T>> items,
    final List<DropdownData<T>> selectedItems = const [],
    final String? hintText,
    final void Function(List<T> selectedItems)? onChanged,
    final TextStyle? style,
    final TextStyle? hintStyle,
    final String? title,
    final BoxDecoration? dropdownDecoration,
  }) : _child = _DropdownMultiSelectionTextFormField(
          items: items,
          selectedItems: selectedItems,
          hintText: hintText,
          title: title,
          onChanged: onChanged,
          style: style,
          hintStyle: hintStyle,
          // dropdownDecoration: dropdownDecoration,
        );

  AppTextFormField.multiSelectionDropdownV2({
    super.key,
    required final List<DropdownData<T>> items,
    final List<T> selectedItems = const [],
    final String? hintText,
    final void Function(List<T> selectedItems)? onChanged,
    final TextStyle? style,
    final TextStyle? hintStyle,
    final String? title,
    final BoxDecoration? dropdownDecoration,
  }) : _child = _DropDownMultiSectionFormFieldV2(
          items: items,
          initialValue: selectedItems,
          hintText: hintText,
          // title: title,
          onSelectionChanged: onChanged,
          style: style,
          hintStyle: hintStyle,
          // dropdownDecoration: dropdownDecoration,
        );

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}

class _AppTextFormField extends StatelessWidget {
  final String? initialValue;
  final String? title;
  final ValueChanged<String>? onChanged;
  final String? Function(String? value)? validator;
  final String? hintText;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final AutovalidateMode? autovalidateMode;

  const _AppTextFormField({
    this.initialValue,
    this.title,
    this.onChanged,
    this.validator,
    this.hintText,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.inputFormatters,
    this.controller,
    this.textCapitalization,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!, style: context.titleSmall),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          initialValue: initialValue,
          keyboardType: keyboardType,
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          textInputAction: textInputAction,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }
}

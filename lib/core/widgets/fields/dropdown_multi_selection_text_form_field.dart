part of 'app_text_form_field.dart';

class _DropdownMultiSelectionTextFormField<T> extends StatefulWidget {
  final List<DropdownData<T>> items;
  final List<DropdownData<T>> selectedItems;
  final String? hintText;
  final String? title;
  final void Function(List<T> selectedItems)? onChanged;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const _DropdownMultiSelectionTextFormField({
    super.key,
    required this.items,
    required this.selectedItems,
    this.hintText,
    this.title,
    this.onChanged,
    this.style,
    this.hintStyle,
    this.validator,
    this.suffixIcon,
  });

  @override
  State<_DropdownMultiSelectionTextFormField<T>> createState() => _DropdownMultiSelectionTextFormFieldState<T>();
}

class _DropdownMultiSelectionTextFormFieldState<T> extends State<_DropdownMultiSelectionTextFormField<T>> {
  late List<DropdownData<T>> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  void _showMultiSelectDialog() async {
    final List<DropdownData<T>>? selected = (await context.showAppGeneralDialog(
      title: widget.title ?? AppStrings.selectItems,
      child: MultiSelectDialog(
        items: widget.items,
        selectedItems: _selectedItems,
      ),
    )) as List<DropdownData<T>>?;
    debugPrint('_DropdownMultiSelectionTextFormFieldState._showMultiSelectDialog: $selected');
    // debugPrint('_DropdownMultiSelectionTextFormFieldState._showMultiSelectDialog: $selected1');
    // final List<DropdownData<T>>? selected = await showDialog<List<DropdownData<T>>>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return MultiSelectDialog(
    //       items: widget.items,
    //       selectedItems: _selectedItems,
    //       style: widget.style,
    //     );
    //   },
    // );

    if (selected != null) {
      setState(() {
        _selectedItems = selected;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(_selectedItems.map((e) => e.value).toList());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) Text(widget.title!, style: context.titleSmall),
        AppTextFormField(
          onTap: _showMultiSelectDialog,
          readOnly: true,
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon ?? Icon(Icons.keyboard_arrow_down),
          validator: widget.validator,
        ),
      ],
    );
  }
}

class MultiSelectDialog<T> extends StatefulWidget {
  final List<DropdownData<T>> items;
  final List<DropdownData<T>> selectedItems;
  final TextStyle? style;

  const MultiSelectDialog({
    super.key,
    required this.items,
    required this.selectedItems,
    this.style,
  });

  @override
  State<MultiSelectDialog<T>> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T> extends State<MultiSelectDialog<T>> {
  late List<DropdownData<T>> _tempSelectedItems;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: context.height * 0.5, maxWidth: context.width),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: widget.items.map((item) {
                final isSelected = _tempSelectedItems.contains(item);
                return CheckboxListTile(
                  activeColor: context.primary,
                  value: isSelected,
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  title: Text(item.label, style: widget.style ?? context.titleMedium!),
                  onChanged: (bool? checked) {
                    setState(() {
                      if (checked == true) {
                        _tempSelectedItems.add(item);
                      } else {
                        _tempSelectedItems.remove(item);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ).expanded(),
          // action at the bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: Text(AppStrings.cancel, style: context.titleSmall),
              ).expanded(),
              AppButton(
                height: 40.0,
                onPressed: () => Navigator.pop(context, _tempSelectedItems),
                child: Text(AppStrings.ok),
              ).expanded(),
            ],
          ).padding(EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
        ],
      ),
    );
  }
}

class _DropDownMultiSectionFormFieldV2<T> extends StatefulWidget {
  final List<T>? initialValue;
  final List<DropdownData<T>> items;
  final void Function(List<T> values)? onSelectionChanged;
  final Widget? prefixIcon;
  final String? hintText;
  final String? labelText;
  final String? Function(String? value)? validator;
  final EdgeInsets? contentPadding;
  final TextStyle? sectionTitleStyle;
  final TextStyle? itemStyle;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final bool updatedBorders;

  const _DropDownMultiSectionFormFieldV2({
    super.key,
    this.initialValue,
    required this.items,
    this.onSelectionChanged,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.contentPadding,
    this.sectionTitleStyle,
    this.itemStyle,
    this.hintStyle,
    this.labelText,
    this.style,
    this.updatedBorders = false,
  });

  @override
  State<_DropDownMultiSectionFormFieldV2<T>> createState() => _DropDownMultiSectionFormFieldState<T>();
}

class _DropDownMultiSectionFormFieldState<T> extends State<_DropDownMultiSectionFormFieldV2<T>> {
  late ValueNotifier<List<T>> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = ValueNotifier<List<T>>(widget.initialValue ?? []);
  }

  @override
  void dispose() {
    _selectedValues.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: _selectedValues,
      builder: (context, selectedValues, _) {
        return DropdownButtonFormField2<T>(
          isExpanded: true,
          value: null,
          // Keep this null to avoid selection display
          validator: (value) => widget.validator?.call(value?.toString()),
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            contentPadding: widget.contentPadding,
            isDense: true,
            label: widget.labelText != null ? Text(context.tr(widget.labelText!)) : null,
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
          ),
          hint: widget.hintText == null ? null : Text(widget.hintText!, style: widget.hintStyle),
          style: widget.style ?? context.titleMedium!,
          items: widget.items.map((item) {
            return DropdownMenuItem<T>(
              enabled: false, // Disable default selection behavior
              value: item.value,
              child: StatefulBuilder(
                // Use StatefulBuilder to handle local state updates
                builder: (BuildContext context, StateSetter setStateLocal) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: selectedValues.contains(item.value),
                    onChanged: (isChecked) {
                      setStateLocal(() {
                        if (isChecked == true) {
                          if (!selectedValues.contains(item.value)) {
                            selectedValues = [...selectedValues, item.value];
                          }
                        } else {
                          selectedValues = selectedValues.where((v) => v != item.value).toList();
                        }
                        _selectedValues.value = selectedValues;
                        widget.onSelectionChanged?.call(selectedValues);
                      });
                    },
                    title: Text(context.tr(item.label), style: widget.itemStyle),
                  );
                },
              ),
            );
          }).toList(),
          iconStyleData: IconStyleData(icon: Icon(LucideIcons.chevronDown, color: Colors.grey)),
          dropdownStyleData: DropdownStyleData(
            elevation: 0,
            offset: const Offset(0.0, -5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.zero),
          onChanged: (value) {
            // Keep dropdown open, no action needed
          },
        );
      },
    );
  }
}

import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';

class AppCheckboxTile extends StatefulWidget {
  final Text title;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const AppCheckboxTile({
    super.key,
    required this.title,
    this.value = false,
    this.onChanged,
  });

  @override
  State<AppCheckboxTile> createState() => _AppCheckboxTileState();
}

class _AppCheckboxTileState extends State<AppCheckboxTile> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isChecked = !_isChecked);
        widget.onChanged?.call(_isChecked);
      },
      child: Row(
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: context.bodyMedium!,
              child: widget.title,
            ),
          ),
          Checkbox(
            value: _isChecked,
            onChanged: (value) {
              widget.onChanged?.call(value);
              setState(() => _isChecked = value ?? false);
            },
          ),
        ],
      ),
    );
  }
}

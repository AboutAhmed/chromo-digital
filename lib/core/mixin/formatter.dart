import 'package:flutter/services.dart';

mixin Formatter {
  List<TextInputFormatter> get decimalFormatters => [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))];

  List<TextInputFormatter> get germanCurrencyFormatters => [
        // 4 digit max before comma and 3 after comma max
        FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}(,\d{0,3})?$')),
      ];

  List<TextInputFormatter> get numberFormatters => [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))];
}

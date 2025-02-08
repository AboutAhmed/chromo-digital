import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';

extension ColumnExtension on Column {
  Column childrenPadding(EdgeInsets padding) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: children.map((e) => e.padding(padding)).toList(),
    );
  }
}

extension RowExtension on Row {
  Row childrenPadding(EdgeInsets padding) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: children.map((e) => e.padding(padding)).toList(),
    );
  }
}

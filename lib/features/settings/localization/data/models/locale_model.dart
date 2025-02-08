import 'dart:ui';

import 'package:equatable/equatable.dart';

class LocaleModel extends Equatable {
  final String label;
  final Locale locale;

  const LocaleModel({
    required this.label,
    required this.locale,
  });

  factory LocaleModel.fromJson(Map<String, dynamic> map) {
    return LocaleModel(
      label: map['label'],
      locale: map['locale'],
    );
  }

  @override
  List<Object?> get props => [label, locale];
}

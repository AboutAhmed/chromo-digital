import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'theme_model.g.dart';

@JsonSerializable()
class ThemeModel extends Equatable {
  // const ThemeModel({
  //   required super.name,
  //   super.description,
  //   required super.themeMode,
  // });

  final String name;
  final String? description;
  final ThemeMode themeMode;

  const ThemeModel({
    required this.name,
    this.description,
    required this.themeMode,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) => _$ThemeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThemeModelToJson(this);

  @override
  List<Object?> get props => [name, description, themeMode];
}

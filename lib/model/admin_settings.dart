import 'package:admin_app/model/settings_item.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_settings.g.dart';

@JsonSerializable(nullable: true)
class AdminSettings extends Equatable {
  final String version;
  final String createdBy;
  final num createdAt;
  final num deletedAt;
  @JsonKey(ignore: true)
  List<SettingsItem> items;

  AdminSettings({
    @required this.version,
    @required this.createdBy,
    @required this.createdAt,
    this.items = const [],
    this.deletedAt,
  });

  factory AdminSettings.fromJson(Map<String, dynamic> json) =>
      _$AdminSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AdminSettingsToJson(this);

  @override
  List<Object> get props => [
        this.version,
        this.createdBy,
        this.createdAt,
        this.deletedAt,
      ];
}

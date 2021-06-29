// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSettings _$AdminSettingsFromJson(Map<String, dynamic> json) {
  return AdminSettings(
    version: json['version'] as String,
    createdBy: json['createdBy'] as String,
    createdAt: json['createdAt'] as num,
    deletedAt: json['deletedAt'] as num,
  );
}

Map<String, dynamic> _$AdminSettingsToJson(AdminSettings instance) =>
    <String, dynamic>{
      'version': instance.version,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'deletedAt': instance.deletedAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String,
    destinationUserId: json['destinationUserId'] as String,
    message: json['message'] as String,
    action: _$enumDecode(_$NotificationActionEnumMap, json['action']),
    data: json['data'] as Map<String, dynamic>,
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'destinationUserId': instance.destinationUserId,
      'message': instance.message,
      'action': _$NotificationActionEnumMap[instance.action],
      'data': instance.data,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$NotificationActionEnumMap = {
  NotificationAction.NONE: 'NONE',
};

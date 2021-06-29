// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_rooms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRooms _$ChatRoomsFromJson(Map<String, dynamic> json) {
  return ChatRooms(
    id: json['id'] as String,
    storeId: json['storeId'] as String,
    customerId: json['customerId'] as String,
    name: json['name'] as String,
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    lastMessage: json['lastMessage'] as String,
    read: json['read'] as bool,
    roomType: _$enumDecode(_$RoomTypeEnumMap, json['roomType']),
  );
}

Map<String, dynamic> _$ChatRoomsToJson(ChatRooms instance) => <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'customerId': instance.customerId,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'lastMessage': instance.lastMessage,
      'read': instance.read,
      'roomType': _$RoomTypeEnumMap[instance.roomType],
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

const _$RoomTypeEnumMap = {
  RoomType.REQUEST_STORE: 'REQUEST_STORE',
  RoomType.REQUEST_RIDER: 'REQUEST_RIDER',
  RoomType.DEFAULT: 'DEFAULT',
};

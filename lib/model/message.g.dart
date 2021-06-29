// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    id: json['id'] as String,
    chatRoomId: json['chatRoomId'] as String,
    ownerId: json['ownerId'] as String,
    message: json['message'] as String,
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'message': instance.message,
      'chatRoomId': instance.chatRoomId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) {
  return Store(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    profileUrl: json['profileUrl'] as String,
    coverUrl: json['coverUrl'] as String,
    addressId: json['addressId'] as String,
    contactNumber: json['contactNumber'] as String,
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    deletedNote: json['deletedNote'] as String,
  );
}

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'profileUrl': instance.profileUrl,
      'coverUrl': instance.coverUrl,
      'addressId': instance.addressId,
      'contactNumber': instance.contactNumber,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'deletedNote': instance.deletedNote,
    };

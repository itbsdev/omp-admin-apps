// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) {
  return Tag(
    id: json['id'] as String,
    productId: json['productId'] as String,
    tag: json['tag'] as String,
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
  );
}

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'tag': instance.tag,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
    };

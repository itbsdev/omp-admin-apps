// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    longitude: (json['longitude'] as num)?.toDouble(),
    latitude: (json['latitude'] as num)?.toDouble(),
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
    };

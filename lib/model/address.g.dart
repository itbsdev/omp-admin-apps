// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    id: json['id'] as String,
    userId: json['userId'] as String,
    isDefault: json['isDefault'] as bool,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    street: json['street'] as String,
    city: json['city'] as String,
    region: json['region'] as String,
    zip: json['zip'] as String,
    municipality: json['municipality'] as String,
    province: json['province'] as String,
    houseNumber: json['houseNumber'] as String,
    barangay: json['barangay'] as String,
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    name: json['name'] as String,
    country: json['country'] as String,
    storeId: json['storeId'] as String,
    alternateCompleteAddress: json['alternateCompleteAddress'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'storeId': instance.storeId,
      'name': instance.name,
      'isDefault': instance.isDefault,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'street': instance.street,
      'city': instance.city,
      'region': instance.region,
      'zip': instance.zip,
      'municipality': instance.municipality,
      'province': instance.province,
      'houseNumber': instance.houseNumber,
      'barangay': instance.barangay,
      'country': instance.country,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'alternateCompleteAddress': instance.alternateCompleteAddress,
    };

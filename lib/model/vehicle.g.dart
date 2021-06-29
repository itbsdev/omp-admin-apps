// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) {
  return Vehicle(
    id: json['id'] as String,
    riderId: json['riderId'] as String,
    isDefault: json['isDefault'] as bool,
    inUse: json['inUse'] as bool,
    model: json['model'] as String,
    brand: json['brand'] as String,
    year: json['year'] as int,
    type: _$enumDecodeNullable(_$VehicleTypeEnumMap, json['type']),
    plateNumber: json['plateNumber'] as String,
    engineNumber: json['engineNumber'] as String,
    chassisNumber: json['chassisNumber'] as String,
    color: json['color'] as String,
    mediaUrls: (json['mediaUrls'] as List)?.map((e) => e as String)?.toList(),
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
  );
}

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'riderId': instance.riderId,
      'isDefault': instance.isDefault,
      'inUse': instance.inUse,
      'model': instance.model,
      'brand': instance.brand,
      'year': instance.year,
      'type': _$VehicleTypeEnumMap[instance.type],
      'plateNumber': instance.plateNumber,
      'engineNumber': instance.engineNumber,
      'chassisNumber': instance.chassisNumber,
      'color': instance.color,
      'mediaUrls': instance.mediaUrls,
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

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$VehicleTypeEnumMap = {
  VehicleType.BIKE: 'BIKE',
  VehicleType.MOTORCYCLE: 'MOTORCYCLE',
  VehicleType.SEDAN: 'SEDAN',
  VehicleType.AUV: 'AUV',
  VehicleType.PICKUP: 'PICKUP',
  VehicleType.SUV: 'SUV',
  VehicleType.TRUCK: 'TRUCK',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsItem _$SettingsItemFromJson(Map<String, dynamic> json) {
  return SettingsItem(
    name: _$enumDecodeNullable(_$AdminSettingsItemFieldsEnumMap, json['name']),
    value: json['value'],
    createdAt: json['createdAt'] as num,
  );
}

Map<String, dynamic> _$SettingsItemToJson(SettingsItem instance) =>
    <String, dynamic>{
      'name': _$AdminSettingsItemFieldsEnumMap[instance.name],
      'value': instance.value,
      'createdAt': instance.createdAt,
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

const _$AdminSettingsItemFieldsEnumMap = {
  AdminSettingsItemFields.WEIGHT: 'WEIGHT',
  AdminSettingsItemFields.PRICE_PER_WEIGHT: 'PRICE_PER_WEIGHT',
  AdminSettingsItemFields.VOLUME: 'VOLUME',
  AdminSettingsItemFields.PRICE_PER_VOLUME: 'PRICE_PER_VOLUME',
  AdminSettingsItemFields.DISTANCE: 'DISTANCE',
  AdminSettingsItemFields.PRICE_PER_DISTANCE: 'PRICE_PER_DISTANCE',
  AdminSettingsItemFields.PRICE_PERCENTAGE: 'PRICE_PERCENTAGE',
  AdminSettingsItemFields.BIKE_CHARGE: 'BIKE_CHARGE',
  AdminSettingsItemFields.MOTORCYCLE_CHARGE: 'MOTORCYCLE_CHARGE',
  AdminSettingsItemFields.SEDAN_CHARGE: 'SEDAN_CHARGE',
  AdminSettingsItemFields.AUV_CHARGE: 'AUV_CHARGE',
  AdminSettingsItemFields.PICKUP_CHARGE: 'PICKUP_CHARGE',
  AdminSettingsItemFields.SUV_CHARGE: 'SUV_CHARGE',
  AdminSettingsItemFields.TRUCK_CHARGE: 'TRUCK_CHARGE',
  AdminSettingsItemFields.BASE_DELIVERY_CHARGE: 'BASE_DELIVERY_CHARGE',
  AdminSettingsItemFields.BASE_ORDER_DELIVERY_CHARGE:
      'BASE_ORDER_DELIVERY_CHARGE',
};

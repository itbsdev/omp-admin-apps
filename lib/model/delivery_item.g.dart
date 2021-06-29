// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryItem _$DeliveryItemFromJson(Map<String, dynamic> json) {
  return DeliveryItem(
    id: json['id'] as String,
    deliveryId: json['deliveryId'] as String,
    type: _$enumDecode(_$RiderServiceTypeEnumMap, json['type']),
    typeId: json['typeId'] as String,
    item: json['item'] as String,
    quantity: json['quantity'] as int,
    price: (json['price'] as num).toDouble(),
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    itemId: json['itemId'] as String,
    pickedUpAt: json['pickedUpAt'] as num,
    itemCompleteAddress: json['itemCompleteAddress'] as String,
  );
}

Map<String, dynamic> _$DeliveryItemToJson(DeliveryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deliveryId': instance.deliveryId,
      'type': _$RiderServiceTypeEnumMap[instance.type],
      'typeId': instance.typeId,
      'item': instance.item,
      'itemId': instance.itemId,
      'quantity': instance.quantity,
      'price': instance.price,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'pickedUpAt': instance.pickedUpAt,
      'itemCompleteAddress': instance.itemCompleteAddress,
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

const _$RiderServiceTypeEnumMap = {
  RiderServiceType.PADALA: 'PADALA',
  RiderServiceType.PABILI: 'PABILI',
  RiderServiceType.PASAKAY: 'PASAKAY',
  RiderServiceType.ORDER: 'ORDER',
};

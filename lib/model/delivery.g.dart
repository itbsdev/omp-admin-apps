// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) {
  return Delivery(
    id: json['id'] as String,
    riderId: json['riderId'] as String,
    vehicleId: json['vehicleId'] as String,
    destinationAddress: json['destinationAddress'] as String,
    sourceAddress: json['sourceAddress'] as String,
    receiverName: json['receiverName'] as String,
    receiverMobileNumber: json['receiverMobileNumber'] as String,
    bookerId: json['bookerId'] as String,
    status: _$enumDecodeNullable(_$DeliveryStatusEnumMap, json['status']),
    type: _$enumDecodeNullable(_$RiderServiceTypeEnumMap, json['type']),
    paymentMethod:
        _$enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']),
    totalPayment: json['totalPayment'] as num,
    vehicleType:
        _$enumDecodeNullable(_$VehicleTypeEnumMap, json['vehicleType']),
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    destinationAddressId: json['destinationAddressId'] as String,
    sourceAddressId: json['sourceAddressId'] as String,
    notes: json['notes'] as String,
    completedAt: json['completedAt'] as num,
  );
}

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      'id': instance.id,
      'riderId': instance.riderId,
      'vehicleId': instance.vehicleId,
      'destinationAddressId': instance.destinationAddressId,
      'destinationAddress': instance.destinationAddress,
      'sourceAddressId': instance.sourceAddressId,
      'sourceAddress': instance.sourceAddress,
      'receiverName': instance.receiverName,
      'receiverMobileNumber': instance.receiverMobileNumber,
      'bookerId': instance.bookerId,
      'notes': instance.notes,
      'status': _$DeliveryStatusEnumMap[instance.status],
      'type': _$RiderServiceTypeEnumMap[instance.type],
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod],
      'totalPayment': instance.totalPayment,
      'vehicleType': _$VehicleTypeEnumMap[instance.vehicleType],
      'completedAt': instance.completedAt,
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

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.REQUESTING: 'REQUESTING',
  DeliveryStatus.ACCEPTED: 'ACCEPTED',
  DeliveryStatus.PICKED_UP: 'PICKED_UP',
  DeliveryStatus.ON_THE_WAY: 'ON_THE_WAY',
  DeliveryStatus.WITHIN_VICINITY: 'WITHIN_VICINITY',
  DeliveryStatus.COMPLETED: 'COMPLETED',
  DeliveryStatus.CANCELLED: 'CANCELLED',
};

const _$RiderServiceTypeEnumMap = {
  RiderServiceType.PADALA: 'PADALA',
  RiderServiceType.PABILI: 'PABILI',
  RiderServiceType.PASAKAY: 'PASAKAY',
  RiderServiceType.ORDER: 'ORDER',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.COD: 'COD',
  PaymentMethod.OVER_THE_COUNTER: 'OVER_THE_COUNTER',
  PaymentMethod.WEB_BANKING: 'WEB_BANKING',
  PaymentMethod.DEBIT_CARDS: 'DEBIT_CARDS',
  PaymentMethod.E_WALLET: 'E_WALLET',
  PaymentMethod.E_PAYMENT: 'E_PAYMENT',
};

const _$VehicleTypeEnumMap = {
  VehicleType.BIKE: 'BIKE',
  VehicleType.MOTORCYCLE: 'MOTORCYCLE',
  VehicleType.SEDAN: 'SEDAN',
  VehicleType.AUV: 'AUV',
  VehicleType.PICKUP: 'PICKUP',
  VehicleType.SUV: 'SUV',
  VehicleType.TRUCK: 'TRUCK',
};

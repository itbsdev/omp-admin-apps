// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    id: json['id'] as String,
    status: _$enumDecodeNullable(_$OrderStatusEnumMap, json['status']),
    customerId: json['customerId'] as String,
    productId: json['productId'] as String,
    storeId: json['storeId'] as String,
    quantity: json['quantity'] as num,
    price: (json['price'] as num)?.toDouble(),
    deliveryId: json['deliveryId'] as String,
    shipToAddressId: json['shipToAddressId'] as String,
    dateCompleted: json['dateCompleted'] as int,
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    receiverName: json['receiverName'] as String,
    receiverAddress: json['receiverAddress'] as String,
    receiverMobileNumber: json['receiverMobileNumber'] as String,
    paymentMethod:
        _$enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'status': _$OrderStatusEnumMap[instance.status],
      'customerId': instance.customerId,
      'productId': instance.productId,
      'storeId': instance.storeId,
      'quantity': instance.quantity,
      'price': instance.price,
      'deliveryId': instance.deliveryId,
      'shipToAddressId': instance.shipToAddressId,
      'dateCompleted': instance.dateCompleted,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'receiverName': instance.receiverName,
      'receiverAddress': instance.receiverAddress,
      'receiverMobileNumber': instance.receiverMobileNumber,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod],
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

const _$OrderStatusEnumMap = {
  OrderStatus.PENDING: 'PENDING',
  OrderStatus.SUBMITTED: 'SUBMITTED',
  OrderStatus.APPROVED: 'APPROVED',
  OrderStatus.REJECTED: 'REJECTED',
  OrderStatus.CANCELLED: 'CANCELLED',
  OrderStatus.ON_DELIVERY: 'ON_DELIVERY',
  OrderStatus.DELIVERED: 'DELIVERED',
  OrderStatus.COMPLETE: 'COMPLETE',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.COD: 'COD',
  PaymentMethod.OVER_THE_COUNTER: 'OVER_THE_COUNTER',
  PaymentMethod.WEB_BANKING: 'WEB_BANKING',
  PaymentMethod.DEBIT_CARDS: 'DEBIT_CARDS',
  PaymentMethod.E_WALLET: 'E_WALLET',
  PaymentMethod.E_PAYMENT: 'E_PAYMENT',
};

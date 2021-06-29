import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part "order.g.dart";

@JsonSerializable(nullable: true)
class Order extends Equatable {
  final String id;
  final OrderStatus status;
  final String customerId;
  final String productId;
  final String storeId;
  final num quantity;
  final double price;
  final String deliveryId;
  final String shipToAddressId;
  final int dateCompleted;
  final num createdAt;
  final num updatedAt;
  final num deletedAt;
  final String receiverName;
  final String receiverAddress;
  final String receiverMobileNumber;
  final PaymentMethod paymentMethod;

  const Order({
    @required this.id,
    @required this.status,
    @required this.customerId,
    @required this.productId,
    @required this.storeId,
    @required this.quantity,
    @required this.price,
    @required this.deliveryId,
    @required this.shipToAddressId,
    @required this.dateCompleted,
    @required this.createdAt,
    @required this.updatedAt,
    this.deletedAt,
    this.receiverName,
    this.receiverAddress,
    this.receiverMobileNumber,
    this.paymentMethod
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  List<Object> get props => [
    this.id,
    this.status,
    this.customerId,
    this.productId,
    this.storeId,
    this.quantity,
    this.price,
    this.deliveryId,
    this.shipToAddressId,
    this.dateCompleted,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.receiverName,
    this.receiverAddress,
    this.receiverMobileNumber,
    this.paymentMethod
  ];
}

enum OrderStatus {
  PENDING,
  SUBMITTED,
  APPROVED,
  REJECTED,
  CANCELLED,
  ON_DELIVERY,
  DELIVERED,
  COMPLETE
}

enum PaymentMethod {
  COD,
  OVER_THE_COUNTER,
  WEB_BANKING,
  DEBIT_CARDS,
  E_WALLET,
  E_PAYMENT
}

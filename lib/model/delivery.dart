import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:admin_app/model/delivery_item.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/model/vehicle.dart';

part 'delivery.g.dart';

@JsonSerializable(nullable: true)
class Delivery extends Equatable {
  final String id;
  final String riderId;
  final String vehicleId;
  final String destinationAddressId;
  final String destinationAddress;
  final String sourceAddressId;
  final String sourceAddress;
  final String receiverName;
  final String receiverMobileNumber;
  final String bookerId;
  final String notes;
  DeliveryStatus status;
  final RiderServiceType type;
  final num createdAt;
  num updatedAt;
  num deletedAt;
  @JsonKey(ignore: true) List<DeliveryItem> items;
  final PaymentMethod paymentMethod;
  final num totalPayment;
  // the requested vehicle type
  final VehicleType vehicleType;
  num completedAt;

  Delivery({
    @required this.id,
    @required this.riderId,
    @required this.vehicleId,
    @required this.destinationAddress,
    @required this.sourceAddress,
    @required this.receiverName,
    @required this.receiverMobileNumber,
    @required this.bookerId,
    @required this.status,
    @required this.type,
    @required this.paymentMethod,
    @required this.totalPayment,
    @required this.vehicleType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.destinationAddressId,
    this.sourceAddressId,
    this.items,
    this.notes,
    this.completedAt,
});

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);

  @override
  List<Object> get props => [
    this.id,
    this.riderId,
    this.vehicleId,
    this.destinationAddress,
    this.sourceAddress,
    this.receiverName,
    this.receiverMobileNumber,
    this.bookerId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.status,
    this.destinationAddressId,
    this.sourceAddressId,
    this.type,
    this.items,
    this.notes,
    this.paymentMethod,
    this.totalPayment,
    this.vehicleType,
    this.completedAt,
  ];

}

enum DeliveryStatus {
  REQUESTING,
  ACCEPTED,
  PICKED_UP,
  ON_THE_WAY,
  WITHIN_VICINITY,
  COMPLETED,
  CANCELLED
}

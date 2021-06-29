import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:admin_app/model/rider.dart';

part 'delivery_item.g.dart';

@JsonSerializable(nullable: false)
class DeliveryItem extends Equatable {
  final String id;
  final String deliveryId;
  final RiderServiceType type;
  /// when type is ORDER, typeId will be
  /// the orderId
  String typeId;
  final String item;
  String itemId;
  final int quantity;
  final double price;
  final num createdAt;
  num updatedAt;
  num deletedAt;
  num pickedUpAt;
  String itemCompleteAddress;
  @JsonKey(ignore: true)
  String itemPhoto;

  DeliveryItem({
    @required this.id,
    this.deliveryId,
    @required this.type,
    this.typeId,
    @required this.item,
    @required this.quantity,
    @required this.price,
    @required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.itemId,
    this.pickedUpAt,
    this.itemCompleteAddress,
    this.itemPhoto
});

  factory DeliveryItem.fromJson(Map<String, dynamic> json) =>
      _$DeliveryItemFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryItemToJson(this);

  @override
  List<Object> get props => [
    this.id,
    this.deliveryId,
    this.type,
    this.typeId,
    this.item,
    this.quantity,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.itemId,
    this.itemPhoto
  ];

}



import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_item.g.dart';

@JsonSerializable(nullable: true)
class SettingsItem extends Equatable {
  final AdminSettingsItemFields name;
  final dynamic value;
  final num createdAt;

  const SettingsItem({
    @required this.name,
    @required this.value,
    @required this.createdAt,
  });

  factory SettingsItem.fromJson(Map<String, dynamic> json) =>
      _$SettingsItemFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsItemToJson(this);

  @override
  List<Object> get props => [
        this.name,
        this.value,
        this.createdAt,
      ];
}

enum AdminSettingsItemFields {
  /// measured in grams
  WEIGHT,
  PRICE_PER_WEIGHT,

  /// measured in cubic mm (mm3)
  VOLUME,
  PRICE_PER_VOLUME,

  /// measured in km
  DISTANCE,
  PRICE_PER_DISTANCE,
  PRICE_PERCENTAGE,
  BIKE_CHARGE,
  MOTORCYCLE_CHARGE,
  SEDAN_CHARGE,
  AUV_CHARGE,
  PICKUP_CHARGE,
  SUV_CHARGE,
  TRUCK_CHARGE,
  BASE_DELIVERY_CHARGE,
  BASE_ORDER_DELIVERY_CHARGE
}

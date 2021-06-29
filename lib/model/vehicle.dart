import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable(nullable: true)
class Vehicle extends Equatable {
  final String id;
  final String riderId;
  final bool isDefault;
  final bool inUse;
  final String model;
  final String brand;
  final int year;
  final VehicleType type;
  final String plateNumber;
  final String engineNumber;
  final String chassisNumber;
  final String color;
  final List <String> mediaUrls;
  final num createdAt;
  num updatedAt;
  num deletedAt;

  Vehicle({
    @required this.id,
    @required this.riderId,
    @required this.isDefault,
    @required this.inUse,
    @required this.model,
    @required this.brand,
    @required this.year,
    @required this.type,
    @required this.plateNumber,
    this.engineNumber,
    this.chassisNumber,
    @required this.color,
    @required this.mediaUrls,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
});

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  @override
  List<Object> get props => [
    this.id,
    this.riderId,
    this.isDefault,
    this.inUse,
    this.model,
    this.brand,
    this.year,
    this.type,
    this.plateNumber,
    this.engineNumber,
    this.chassisNumber,
    this.color,
    this.mediaUrls,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  ];

  @override
  String toString() {
    return "$year ${color.toUpperCase()} $brand $model";
  }
}

enum VehicleType {
  BIKE,
  MOTORCYCLE,
  SEDAN,
  AUV,
  PICKUP,
  SUV,
  TRUCK,
}

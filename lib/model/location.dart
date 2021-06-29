import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(nullable: true)
class Location extends Equatable {
  final String id;
  final String vehicleId;
  final double longitude;
  final double latitude;
  final num createdAt;
  num updatedAt;
  num deletedAt;

  Location({
    @required this.id,
    @required this.vehicleId,
    @required this.longitude,
    @required this.latitude,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
});

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  List<Object> get props => [
    this.id,
    this.vehicleId,
    this.longitude,
    this.latitude,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  ];

}

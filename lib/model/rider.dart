import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rider.g.dart';

@JsonSerializable(nullable: true)
class Rider extends Equatable {
  final String id;
  final String name;
  final String email;
  final String mobileNumber;
  final num birthDate;
  final String mediaUrl;
  final bool availability;
  final String userId;
  final num createdAt;
  List<RiderServiceType> serviceAvailability;
  num updatedAt;
  num deletedAt;
  String deletedNote;

  Rider({
    @required this.id,
    @required this.userId,
    @required this.name,
    @required this.email,
    @required this.mobileNumber,
    @required this.birthDate,
    @required this.mediaUrl,
    this.availability = false,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.serviceAvailability,
    this.deletedNote
});

  factory Rider.fromJson(Map<String, dynamic> json) => _$RiderFromJson(json);

  Map<String, dynamic> toJson() => _$RiderToJson(this);

  @override
  List<Object> get props => [
    this.id,
    this.name,
    this.email,
    this.mobileNumber,
    this.birthDate,
    this.mediaUrl,
    this.availability,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.serviceAvailability,
    this.deletedNote
  ];
}

enum RiderServiceType {
  PADALA,
  PABILI,
  PASAKAY,
  ORDER
}

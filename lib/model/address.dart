import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(nullable: true)
class Address extends Equatable {
  final String id;
  final String userId;
  final String storeId;
  final String name;
  final bool isDefault;
  final double latitude;
  final double longitude;
  final String street;
  final String city;
  final String region;
  final String zip;
  final String municipality;
  final String province;
  final String houseNumber;
  final String barangay;
  final String country;
  final num createdAt; // = DateTime.now().toUtc().millisecondsSinceEpoch;
  final num updatedAt;
  final num deletedAt;
  final String alternateCompleteAddress;

  const Address({
    @required this.id,
    @required this.userId,
    @required this.isDefault,
    @required this.latitude,
    @required this.longitude,
    @required this.street,
    @required this.city,
    @required this.region,
    @required this.zip,
    @required this.municipality,
    @required this.province,
    @required this.houseNumber,
    @required this.barangay,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.deletedAt,
    @required this.name,
    @required this.country,
    @required this.storeId,
    this.alternateCompleteAddress
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  List<Object> get props => [
        this.id,
        this.userId,
        this.isDefault,
        this.latitude,
        this.longitude,
        this.street,
        this.city,
        this.region,
        this.zip,
        this.municipality,
        this.province,
        this.houseNumber,
        this.barangay,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.name,
        this.country,
        this.storeId,
    this.alternateCompleteAddress
      ];

  @override
  String toString() {
    if (alternateCompleteAddress != null) {
      return alternateCompleteAddress;
    }

    var addressLine = "";

    if (name != null && name.isNotEmpty) {
      addressLine += "$name, ";
    }

    if (houseNumber != null && houseNumber.isNotEmpty) {
      addressLine += "$houseNumber ";
    }

    if (street != null && street.isNotEmpty) {
      addressLine += "$street, ";
    }

    if (barangay != null && barangay.isNotEmpty) {
      addressLine += "$barangay, ";
    }

    if (municipality != null && municipality.isNotEmpty) {
      addressLine += "$municipality, ";
    }

    if (city != null && city.isNotEmpty) {
      addressLine += "$city, ";
    }

    if (province != null && province.isNotEmpty) {
      addressLine += "$province, ";
    }

    if (region != null && region.isNotEmpty) {
      addressLine += "$region, ";
    }

    if (country != null && country.isNotEmpty) {
      addressLine += "$country, ";
    }

    if (zip != null && zip.isNotEmpty) {
      addressLine += "$zip";
    }

    return addressLine;
  }
}

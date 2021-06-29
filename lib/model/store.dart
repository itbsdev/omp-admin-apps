import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable(nullable: false)
class Store extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  String profileUrl;
  String coverUrl;
  final String addressId;
  final String contactNumber;
  final num createdAt;
  final num updatedAt;
  num deletedAt;
  String deletedNote;

  Store({
    @required this.id,
    @required this.ownerId,
    @required this.name,
    @required this.description,
    this.profileUrl,
    this.coverUrl,
    @required this.addressId,
    @required this.contactNumber,
    @required this.createdAt,
    @required this.updatedAt,
    this.deletedAt,
    this.deletedNote,
});

  factory Store.fromJson(Map<String, dynamic> json) =>
      _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);

  @override
  List<Object> get props => [
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.profileUrl,
    this.coverUrl,
    this.addressId,
    this.contactNumber,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.deletedNote
  ];

}

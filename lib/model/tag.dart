import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable(nullable: false)
class Tag extends Equatable {
  final String id;
  final String productId;
  final String tag;
  final num createdAt;
  final num updatedAt;
  final num deletedAt;

  const Tag({
    @required this.id,
    @required this.productId,
    @required this.tag,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.deletedAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);

  @override
  List<Object> get props => [
        this.id,
        this.productId,
        this.tag,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
      ];
}

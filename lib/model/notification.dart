import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable(nullable: false)
class Notification extends Equatable {
  final String id;
  final String ownerId;
  final String destinationUserId;
  final String message;
  final NotificationAction action;
  final Map<String, dynamic> data;
  final num createdAt;
  final num updatedAt;
  final num deletedAt;

  const Notification({
    @required this.id,
    @required this.ownerId,
    @required this.destinationUserId,
    @required this.message,
    @required this.action,
    @required this.data,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.deletedAt,
});

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  @override
  List<Object> get props => [
    this.id,
    this.ownerId,
    this.destinationUserId,
    this.message,
    this.action,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  ];
}

enum NotificationAction { NONE }

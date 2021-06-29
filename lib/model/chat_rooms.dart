import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_rooms.g.dart';

@JsonSerializable(nullable: false)
class ChatRooms extends Equatable {
  final String id;
  final String storeId;
  final String customerId;
  final String name;
  final num createdAt;
  final num updatedAt;
  final num deletedAt;
  String lastMessage;
  bool read;
  RoomType roomType;

  ChatRooms({
    @required this.id,
    @required this.storeId,
    @required this.customerId,
    @required this.name,
    @required this.createdAt, // = DateTime.now().toUtc().millisecondsSinceEpoch;
    @required this.updatedAt,
    @required this.deletedAt,
    this.lastMessage,
    this.read = false,
    this.roomType = RoomType.DEFAULT
  });

  factory ChatRooms.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomsFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomsToJson(this);

  @override
  List<Object> get props => [
        this.id,
        this.storeId,
        this.customerId,
        this.name,
        this.createdAt, // = DateTime.now().toUtc().millisecondsSinceEpoch;
        this.updatedAt,
        this.deletedAt,
        this.lastMessage,
        this.read
      ];
}

enum RoomType {
  REQUEST_STORE,
  REQUEST_RIDER,
  DEFAULT
}

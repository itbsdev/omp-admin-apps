import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(nullable: false)
class Message extends Equatable {
  final String id;
  final String ownerId;
  final String message;
  final String chatRoomId;
  final num createdAt;
  final num updatedAt;
  final num deletedAt;

  const Message({
    this.id,
    this.chatRoomId,
    this.ownerId,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object> get props => [
        this.id,
        this.chatRoomId,
        this.ownerId,
        this.message,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
      ];
}

import 'package:admin_app/model/chat_rooms.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/model/store.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RequestView extends Equatable {
  final ChatRooms chatRoom;
  final Store store;
  final Rider rider;

  const RequestView({ @required this.chatRoom, this.store, this.rider });

  @override
  List<Object> get props => [
    this.chatRoom,
    this.store,
    this.rider
  ];
}

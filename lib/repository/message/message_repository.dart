import 'package:flutter/material.dart';
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/message.dart';

abstract class MessageRepository with BaseRepository<Message> {
  Future<String> delete({@required String id, @required String chatRoomId});

  Future<Message> load({@required String id, @required String chatRoomId});

  Stream<List<Message>> loadMessages({String chatRoomId});

  Future<Message> getLastMessage({ @required String chatRoomId });
}

import 'package:flutter/material.dart';
import 'package:admin_app/model/message.dart';
import 'package:admin_app/repository/message/message_repository.dart';
import 'package:admin_app/service/messages_firestore_service.dart';

class MessageRepositoryImpl extends MessageRepository {
  final MessagesFirestoreService messagesFirestoreService;

  MessageRepositoryImpl({@required this.messagesFirestoreService});

  @override
  Future<String> delete({String id, String chatRoomId}) {
    return messagesFirestoreService.delete(messageId: id, chatRoomId: chatRoomId);
  }

  @override
  Future<String> insert({Message datum}) {
    return messagesFirestoreService.store(message: datum);
  }

  @override
  Future<Message> load({String id, String chatRoomId}) {
    return messagesFirestoreService.load(messageId: id, chatRoomId: chatRoomId);
  }

  @override
  Stream<List<Message>> loadByCompany({String companyId}) {
    throw UnimplementedError("not yet");
  }

  @override
  Future<String> update({Message datum}) {
    return messagesFirestoreService.update(message: datum);
  }

  @override
  Stream<List<Message>> loadMessages({String chatRoomId}) {
    return messagesFirestoreService.loadByChatRoom(chatroomId: chatRoomId);
  }

  @override
  Future<Message> getLastMessage({String chatRoomId}) {
    return messagesFirestoreService.getLastMessage(chatroomId: chatRoomId);
  }

}

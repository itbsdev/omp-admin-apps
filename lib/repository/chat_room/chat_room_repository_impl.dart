import 'package:flutter/material.dart';
import 'package:admin_app/model/chat_rooms.dart';
import 'package:admin_app/repository/chat_room/chat_room_repository.dart';
import 'package:admin_app/service/chat_rooms_firestore_service.dart';

class ChatRoomRepositoryImpl extends ChatRoomRepository {
  final ChatRoomsFirestoreService chatRoomsFirestoreService;

  ChatRoomRepositoryImpl({@required this.chatRoomsFirestoreService});

  @override
  Future<String> delete({String id}) {
    return chatRoomsFirestoreService.delete(chatRoomsId: id);
  }

  @override
  Future<String> insert({ChatRooms datum}) {
    return chatRoomsFirestoreService.store(chatRooms: datum);
  }

  @override
  Future<ChatRooms> load({String id}) {
    return chatRoomsFirestoreService.load(chatRoomsId: id);
  }

  @override
  Stream<List<ChatRooms>> loadByCompany({String companyId}) {
    return chatRoomsFirestoreService.loadByCompany(companyId);
  }

  @override
  Future<String> update({ChatRooms datum}) {
    return chatRoomsFirestoreService.update(chatRooms: datum);
  }

  @override
  Future<ChatRooms> loadByCustomer({String storeId, String customerId}) {
    return chatRoomsFirestoreService.loadByCustomer(storeId: storeId, customerId: customerId);
  }
}

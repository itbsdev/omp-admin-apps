import 'package:flutter/material.dart';
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/chat_rooms.dart';

abstract class ChatRoomRepository with BaseRepository<ChatRooms> {
  Future<ChatRooms> loadByCustomer({ @required String storeId, @required String customerId});
}

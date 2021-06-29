import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/message.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';

import 'chat_rooms_firestore_service.dart';

class MessagesFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  MessagesFirestoreService({@required this.firestoreParentPathService});

  static const String messagesCollectionName = "messages";

  Future<String> store({@required Message message}) async {
    final doc = _messagesCollection(message.chatRoomId).doc();

    final data = message.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required Message message}) async {
    final doc = _messagesCollection(message.chatRoomId).doc(message.id);
    final data = message.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    return Future.value(message.id);
  }

  Future<String> delete(
      {@required String messageId, @required String chatRoomId}) async {
    final doc = _messagesCollection(chatRoomId).doc(messageId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});

    return Future.value(doc.id);
  }

  Future<Message> load(
      {@required String messageId, @required String chatRoomId}) async {
    final doc = _messagesCollection(chatRoomId).doc(messageId);
    final data = await doc.get();

    return Future.value(Message.fromJson(data.data()));
  }

  Stream<List<Message>> loadByChatRoom({@required String chatroomId}) {
    return _messagesCollection(chatroomId)
        .orderBy("updatedAt", descending: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Message.fromJson(e.data())).toList());
  }

  Future<Message> getLastMessage({@required String chatroomId}) async {
    assert(chatroomId != null);
    assert(chatroomId.isNotEmpty, "Chat room ID is an empty string");

    final snapshot = await _messagesCollection(chatroomId)
        .orderBy("updatedAt", descending: true)
        .limit(1)
        .get();
    final data = snapshot.docs.map((e) => Message.fromJson(e.data())).toList();

    if (data.isNotEmpty && data.length == 1) {
      return Future.value(data.first);
    }

    return Future.value(null);
  }

  CollectionReference _messagesCollection(String chatRoomId) =>
      firestoreParentPathService
          .root()
          .doc("${ChatRoomsFirestoreService.chatRoomsCollectionName}Doc")
          .collection(ChatRoomsFirestoreService.chatRoomsCollectionName)
          .doc(chatRoomId)
          .collection(messagesCollectionName);
}

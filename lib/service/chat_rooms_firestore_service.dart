import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/chat_rooms.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';

class ChatRoomsFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  ChatRoomsFirestoreService({@required this.firestoreParentPathService});

  static const String chatRoomsCollectionName = "chatRooms";

  Future<String> store({@required ChatRooms chatRooms}) async {
    final doc = _chatRoomsCollection().doc();

    final data = chatRooms.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required ChatRooms chatRooms}) async {
    final doc = _chatRoomsCollection().doc(chatRooms.id);
    final data = chatRooms.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    return Future.value(chatRooms.id);
  }

  Future<String> delete({@required String chatRoomsId}) async {
    final doc = _chatRoomsCollection().doc(chatRoomsId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});

    return Future.value(doc.id);
  }

  Future<ChatRooms> load({@required String chatRoomsId}) async {
    final doc = _chatRoomsCollection().doc(chatRoomsId);
    final data = await doc.get();

    return Future.value(ChatRooms.fromJson(data.data()));
  }

  Future<ChatRooms> loadByCustomer({@required String storeId, @required String customerId}) async {
    final snapshot = await _chatRoomsCollection()
        .where("storeId", isEqualTo: storeId)
        .where("customerId", isEqualTo: customerId)
        .where("deletedAt", isNull: true)
        .get();
    final data = snapshot.docs.map((e) => ChatRooms.fromJson(e.data())).toList();

    try {
      return Future.value(data.first);
    } catch (err) {
      return Future.value(null);
    }
  }

  Stream<List<ChatRooms>> loadByCompany(String companyId) {
    return _chatRoomsCollection()
        .where("storeId", isEqualTo: companyId)
        .where("deletedAt", isNull: true)
        .snapshots()
        .map((event) => event.docs.map((e) => ChatRooms.fromJson(e.data())).toList());

//    return _chatRoomsCollection()
//        .where("deletedAt", isNull: true)
//        .snapshots()
//        .map((event) => event.docs.map((e) => ChatRooms.fromJson(e.data())).toList());
  }

  CollectionReference _chatRoomsCollection() => firestoreParentPathService
      .root()
      .doc("${chatRoomsCollectionName}Doc")
      .collection(chatRoomsCollectionName);
}

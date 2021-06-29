import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/user.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';

class UserFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  UserFirestoreService({@required this.firestoreParentPathService});

  static const String userCollectionName = "users";

  Future<String> store({@required User user}) async {
    if (user.id == null)
      return Future.error("Creating user... id must not be null");
    final doc = _usersCollection().doc(user.id);

    final data = user.toJson();
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required User user}) async {
    final doc = _usersCollection().doc(user.id);
    final data = user.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(user.toJson());

    return Future.value(user.id);
  }

  Future<String> delete({@required String userId}) async {
    final doc = _usersCollection().doc(userId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});
    return Future.value(doc.id);
  }

  Future<User> load({@required String userId}) async {
    final doc = _usersCollection().doc(userId);
    final data = await doc.get();

    return Future.value(User.fromJson(data.data()));
  }

  Stream<List<User>> loadAll() {
    return _usersCollection()
        .orderBy("updatedAt", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => User.fromJson(e.data())).toList());
  }

  CollectionReference _usersCollection() => firestoreParentPathService
      .root()
      .doc("${userCollectionName}Doc")
      .collection(userCollectionName);
}

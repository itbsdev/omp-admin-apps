import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/rider.dart';

import 'firestore_parent_path_service.dart';

class RiderFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  RiderFirestoreService({@required this.firestoreParentPathService});

  static const String riderCollectionName = "riders";

  Future<String> store({@required Rider rider}) async {
    final doc = _ridersCollection().doc();

    final data = rider.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required Rider rider}) async {
    final doc = _ridersCollection().doc(rider.id);
    final data = rider.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(rider.toJson());

    return Future.value(rider.id);
  }

  Future<String> delete({@required String riderId}) async {
    final doc = _ridersCollection().doc(riderId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});
    return Future.value(doc.id);
  }

  Future<Rider> load({@required String riderId}) async {
    final doc = _ridersCollection().doc(riderId);
    final data = await doc.get();

    return Future.value(Rider.fromJson(data.data()));
  }

  Future<Rider> loadFromUserId({@required String userId}) async {
    final snapshot = await _ridersCollection()
        .where("userId", isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return Future.value(null);
    }

    final doc = snapshot.docs.first.data();

    return Future.value(Rider.fromJson(doc));
  }

  Stream<List<Rider>> loadAll() {
    return _ridersCollection()
        .orderBy("updatedAt", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Rider.fromJson(e.data())).toList());
  }

  CollectionReference _ridersCollection() => firestoreParentPathService
      .root()
      .doc("${riderCollectionName}Doc")
      .collection(riderCollectionName);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';

class StoresFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  StoresFirestoreService({@required this.firestoreParentPathService});

  static const String storesCollectionName = "stores";

  Future<String> store({@required Store store}) async {
    final doc = _storesCollection().doc();

    final data = store.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required Store store}) async {
    final doc = _storesCollection().doc(store.id);
    final data = store.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    return Future.value(store.id);
  }

  Future<String> delete({@required String storeId}) async {
    final doc = _storesCollection().doc(storeId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});

    return Future.value(doc.id);
  }

  Future<Store> load({@required String storeId}) async {
    final doc = _storesCollection().doc(storeId);
    final data = await doc.get();

    return Future.value(Store.fromJson(data.data()));
  }

  Future<Store> loadByUserId({@required String userId}) async {
    print("store path: ${_storesCollection().path}");
    final doc = _storesCollection().where("ownerId", isEqualTo: userId);
    final data = await doc.get();

    return Future.value(Store.fromJson(data.docs.first.data()));
  }

  Stream<List<Store>> loadAll() {
    return _storesCollection()
        .orderBy("updatedAt", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Store.fromJson(e.data())).toList());
  }

  CollectionReference _storesCollection() => firestoreParentPathService
      .root()
      .doc("${storesCollectionName}Doc")
      .collection(storesCollectionName);
}

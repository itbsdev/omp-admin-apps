import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/address.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';

class AddressFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  AddressFirestoreService({@required this.firestoreParentPathService});

  static const String addressCollectionName = "address";

  Future<String> store({@required Address address}) async {
    final doc = _addressCollection().doc();

    final data = address.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required Address address}) async {
    final doc = _addressCollection().doc(address.id);
    final data = address.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    return Future.value(address.id);
  }

  Future<String> delete({@required String addressId}) async {
    final doc = _addressCollection().doc(addressId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});

    return Future.value(doc.id);
  }

  Future<Address> load({@required String addressId}) async {
    final doc = _addressCollection().doc(addressId);
    final data = await doc.get();

    return Future.value(Address.fromJson(data.data()));
  }

  Future<List<Address>> loadByUserId({@required String userId}) async {
    final snapshots = _addressCollection().where("userId", isEqualTo: userId);
    final data = await snapshots.get();

    return Future.value(
        data.docs.map((e) => Address.fromJson(e.data())).toList());
  }

  Stream<List<Address>> loadAll() {
    final snapshots = _addressCollection().snapshots();
    return snapshots.map(
        (event) => event.docs.map((e) => Address.fromJson(e.data())).toList());
  }

  CollectionReference _addressCollection() => firestoreParentPathService
      .root()
      .doc("${addressCollectionName}Doc")
      .collection(addressCollectionName);
}

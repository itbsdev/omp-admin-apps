import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/delivery.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/delivery_item.dart';

import 'firestore_parent_path_service.dart';

class DeliveryFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  DeliveryFirestoreService({@required this.firestoreParentPathService});

  static const String deliveryCollectionName = "deliveries";

  Future<String> store({@required Delivery delivery}) async {
    if (delivery.items.isEmpty) {
      return Future.error(
          "Creating delivery without items is not a valid operation");
    }

    final doc = _deliveriesCollection().doc();
    final now = DateTime.now().millisecondsSinceEpoch;

    final data = delivery.toJson();
    data["id"] = doc.id;
    data["createdAt"] = now;
    data["updatedAt"] = now;

    await doc.set(data);

    delivery.items.forEach((element) async {
      final itemDoc = _deliveryItemsCollection(doc.id).doc();

      final itemData = element.toJson();
      itemData["id"] = itemDoc.id;
      itemData["deliveryId"] = doc.id;
      itemData["type"] = data["type"];
      itemData["createdAt"] = now;
      itemData["updatedAt"] = now;

      await itemDoc.set(itemData);
    });

    return Future.value(doc.id);
  }

  Future<String> update({@required Delivery delivery}) async {
    final doc = _deliveriesCollection().doc(delivery.id);
    final data = delivery.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    return Future.value(delivery.id);
  }

  Future<String> delete({@required String deliveryId}) async {
    final doc = _deliveriesCollection().doc(deliveryId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});
    return Future.value(doc.id);
  }

  Future<Delivery> load({@required String deliveryId}) async {
    final doc = _deliveriesCollection().doc(deliveryId);
    final data = await doc.get();
    final delivery = Delivery.fromJson(data.data());
    final items = await loadDeliveryItems(deliveryId: deliveryId);
    delivery.items = items;

    return Future.value(delivery);
  }

  Stream<Delivery> listenForDeliveryChanges({@required String deliveryId}) {
    assert(deliveryId != null && deliveryId.isNotEmpty);

    return _deliveriesCollection()
        .doc(deliveryId)
        .snapshots()
        .map((event) => Delivery.fromJson(event.data()));
  }

  Stream<List<Delivery>> listenForDeliveries() {
    return _deliveriesCollection()
        .orderBy("updatedAt", descending: false)
        .snapshots()
        .map((event) => event.docs.map((e) => Delivery.fromJson(e.data())).toList());
  }

  Future<List<DeliveryItem>> loadDeliveryItems(
      {@required String deliveryId}) async {
    final snapshot = await _deliveryItemsCollection(deliveryId).get();
    final data =
    snapshot.docs.map((e) => DeliveryItem.fromJson(e.data())).toList();

    return Future.value(data);
  }

  CollectionReference _deliveriesCollection() => firestoreParentPathService
      .root()
      .doc("${deliveryCollectionName}Doc")
      .collection(deliveryCollectionName);

  CollectionReference _deliveryItemsCollection(String deliveryId) =>
      firestoreParentPathService
          .root()
          .doc("${deliveryCollectionName}Doc")
          .collection(deliveryCollectionName)
          .doc(deliveryId)
          .collection("items");
}

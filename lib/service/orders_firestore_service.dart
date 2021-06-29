import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';

class OrdersFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  OrdersFirestoreService({@required this.firestoreParentPathService});

  static const String ordersCollectionName = "orders";

  Future<String> store({@required Order order}) async {
    final doc = _ordersCollection().doc();

    final data = order.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required Order order}) async {
    final doc = _ordersCollection().doc(order.id);
    final data = order.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    return Future.value(order.id);
  }

  Future<String> delete({@required String orderId}) async {
    final doc = _ordersCollection().doc(orderId);
    final now = DateTime.now().millisecondsSinceEpoch;

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": now, "updatedAt": now});

    return Future.value(doc.id);
  }

  Future<Order> load({@required String orderId}) async {
    final doc = _ordersCollection().doc(orderId);
    final data = await doc.get();

    return Future.value(Order.fromJson(data.data()));
  }

  Stream<List<Order>> loadByCompany({@required String companyId}) {
    return _ordersCollection()
        .where("storeId", isEqualTo: companyId)
        .orderBy("updatedAt")
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Order.fromJson(e.data())).toList());
  }

  Stream<List<Order>> loadAll() {
    return _ordersCollection().orderBy("updatedAt").snapshots().map(
        (event) => event.docs.map((e) => Order.fromJson(e.data())).toList());
  }

  Future<List<Order>> loadByProduct({@required String productId}) async {
    assert(productId != null);

    final snapshot = await _ordersCollection()
        .where("productId", isEqualTo: productId)
        .orderBy("updatedAt", descending: true)
        .get();
    final orders = snapshot.docs.map((e) => Order.fromJson(e.data())).toList();

    return Future.value(orders);
  }

  CollectionReference _ordersCollection() => firestoreParentPathService
      .root()
      .doc("${ordersCollectionName}Doc")
      .collection(ordersCollectionName);
}

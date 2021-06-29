import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';

class ProductFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  ProductFirestoreService({@required this.firestoreParentPathService});

  static const String productsCollectionName = "products";

  Future<String> store({@required Product product}) async {
    final doc = _productsCollection().doc();

    final data = product.toJson();
    data["id"] = doc.id;
    data["categories"] = product.categories.map((e) => e.toJson()).toList();
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required Product product}) async {
    final doc = _productsCollection().doc(product.id);
    final data = product.toJson();
    data["categories"] = product.categories.map((e) => e.toJson()).toList();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    return Future.value(product.id);
  }

  Future<String> delete({@required String productId}) async {
    final doc = _productsCollection().doc(productId);

    // hard delete
//    await doc.delete();
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});

    return Future.value(doc.id);
  }

  Future<Product> load({@required String productId}) async {
    final doc = _productsCollection().doc(productId);
    final data = await doc.get();

    return Future.value(Product.fromJson(data.data()));
  }

  Stream<List<Product>> loadByCompany({@required String companyId}) {
    return _productsCollection()
        .where('storeId', isEqualTo: companyId)
        .where("deletedAt", isNull: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Product.fromJson(e.data())).toList());
  }

  Future<List<Product>> loadByCompanyAsync({@required String companyId}) async {
    final snapshot = await _productsCollection()
        .where('storeId', isEqualTo: companyId)
        .get();

    return snapshot.docs.map((e) => Product.fromJson(e.data())).toList();
  }

  Stream<List<Product>> loadAll() {
    return _productsCollection().snapshots().map(
        (event) => event.docs.map((e) => Product.fromJson(e.data())).toList());
  }

  CollectionReference _productsCollection() => firestoreParentPathService
      .root()
      .doc("${productsCollectionName}Doc")
      .collection(productsCollectionName);
}

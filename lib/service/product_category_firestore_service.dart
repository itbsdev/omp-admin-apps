import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';
import 'package:flutter/foundation.dart';

class ProductCategoryFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  ProductCategoryFirestoreService({@required this.firestoreParentPathService});

  static const String productCategoryCollectionName = "productCategories";

  Future<String> store({@required ProductCategory productCategory}) async {
    final doc = _productCategoriesCollection().doc();

    final data = productCategory.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    if (kDebugMode) {
      final docProd = _productCategoriesCollectionInProd().doc(doc.id);
      docProd.set(data);
    }

    return Future.value(doc.id);
  }

  Future<String> update({@required ProductCategory productCategory}) async {
    final doc = _productCategoriesCollection().doc(productCategory.id);
    final data = productCategory.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    if (kDebugMode) {
      final docProd =
          _productCategoriesCollectionInProd().doc(productCategory.id);
      docProd.update(data);
    }

    return Future.value(productCategory.id);
  }

  Future<String> delete({@required String productCategoryId, bool includeChildren = false}) async {
    final doc = _productCategoriesCollection().doc(productCategoryId);
    final now = DateTime.now().millisecondsSinceEpoch;

    // hard delete
//    await doc.delete();
    await doc.update({"deletedAt": now});

    if (kDebugMode) {
      final docProd =
          _productCategoriesCollectionInProd().doc(productCategoryId);
      docProd.update({"deletedAt": now});
    }

    await firestoreParentPathService.fs.runTransaction((transaction) async {
      final snapshot = await _productCategoriesCollection()
          .where("parentId", isEqualTo: productCategoryId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final batch = firestoreParentPathService.fs.batch();

        snapshot.docs.forEach((element) {
          batch.delete(element.reference);
        });

        await batch.commit();
      }

      if (kDebugMode) {
        final snapshot2 = await _productCategoriesCollectionInProd()
            .where("parentId", isEqualTo: productCategoryId)
            .get();

        if (snapshot2.docs.isNotEmpty) {
          final batch = firestoreParentPathService.fs.batch();

          snapshot.docs.forEach((element) {
            batch.delete(element.reference);
          });

          await batch.commit();
        }
      }

      return Future.value();
    });

    print("categories deleted");

    return Future.value(doc.id);
  }

  Future<ProductCategory> load({@required String productId}) async {
    final doc = _productCategoriesCollection().doc(productId);
    final data = await doc.get();

    return Future.value(ProductCategory.fromJson(data.data()));
  }

  Stream<List<ProductCategory>> loadAll() {
    return _productCategoriesCollection()
        .where("deletedAt", isNull: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => ProductCategory.fromJson(e.data())).toList());
  }

  CollectionReference _productCategoriesCollection() =>
      firestoreParentPathService
          .root()
          .doc("${productCategoryCollectionName}Doc")
          .collection(productCategoryCollectionName);

  CollectionReference _productCategoriesCollectionInProd() =>
      firestoreParentPathService
          .prodRoot()
          .doc("${productCategoryCollectionName}Doc")
          .collection(productCategoryCollectionName);
}

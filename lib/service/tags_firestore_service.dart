import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/tag.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';

class TagsFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  TagsFirestoreService({@required this.firestoreParentPathService});
  static const String tagsCollectionName = "tags";

  Future<String> store({@required Tag tag}) async {
    final doc = _tagsCollection().doc();

    final data = tag.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required Tag tag}) async {
    final doc = _tagsCollection().doc(tag.id);
    final data = tag.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    return Future.value(tag.id);
  }

  Future<String> delete({@required String tagId}) async {
    final doc = _tagsCollection().doc(tagId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});

    return Future.value(doc.id);
  }

  Future<bool> deleteAllFromProduct({@required String productId}) async {
    if (productId == null) return Future.error("Product ID should not be null");
    final snapshots = await _tagsCollection().where("productId", isEqualTo: productId).get();
    final tags = snapshots.docs.map((e) => Tag.fromJson(e.data())).toList();

    for (var tag in tags) {
      final doc = _tagsCollection().doc(tag.id);
      // hard delete
//    await doc.delete();
      // soft delete
      await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});
    }

    return Future.value(true);
  }

  Future<Tag> load({@required String tagId}) async {
    final doc = _tagsCollection().doc(tagId);
    final data = await doc.get();

    return Future.value(Tag.fromJson(data.data()));
  }

  CollectionReference _tagsCollection() => firestoreParentPathService.root().doc("${tagsCollectionName}Doc").collection(tagsCollectionName);
}

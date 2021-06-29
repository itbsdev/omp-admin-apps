import 'package:admin_app/exceptions/settings_not_found_exception.dart';
import 'package:admin_app/model/admin_settings.dart';
import 'package:admin_app/model/settings_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';

import 'chat_rooms_firestore_service.dart';

class AdminSettingsFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  AdminSettingsFirestoreService({@required this.firestoreParentPathService});

  static const String adminSettingsCollectionName = "adminSettings";

  Future<String> store({@required AdminSettings adminSettings}) async {
    final doc = _adminSettingsCollection().doc(adminSettings.version);
    final data = adminSettings.toJson();
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    adminSettings.items.forEach((item) async {
      final itemData = item.toJson();
      final itemDoc =
          _adminSettingsCollectionItems(adminSettings.version).doc(itemData["name"]);

      itemData["id"] = itemDoc.id;
      itemData["createdAt"] = DateTime.now().millisecondsSinceEpoch;

      await itemDoc.set(itemData);
    });

    return Future.value(doc.id);
  }

  Future<String> delete({@required String version}) async {
    final doc = _adminSettingsCollection().doc(version);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});

    return Future.value(doc.id);
  }

  Future<AdminSettings> load({@required String version}) async {
    final doc = _adminSettingsCollection().doc(version);
    final data = await doc.get();
    final itemsSnapshot = await _adminSettingsCollectionItems(version).get();
    final items =
        itemsSnapshot.docs.map((e) => SettingsItem.fromJson(e.data()));
    final settings = AdminSettings.fromJson(data.data());
    settings.items.addAll(items);

    return Future.value(settings);
  }

  Future<AdminSettings> loadLatest() async {
    final latestSnapshot = await _adminSettingsCollection()
        .where("deletedAt", isNull: true)
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get();

    if (latestSnapshot.size <= 0) {
      return Future.error(SettingsNotFoundException());
    }

    final settings = AdminSettings.fromJson(latestSnapshot.docs.first.data());
    final itemsSnapshot =
        await _adminSettingsCollectionItems(settings.version).get();
    final items =
        itemsSnapshot.docs.map((e) => SettingsItem.fromJson(e.data())).toList();

    settings.items = items;

    return Future.value(settings);
  }

  CollectionReference _adminSettingsCollectionItems(String version) =>
      firestoreParentPathService
          .root()
          .doc("settingsDoc")
          .collection(adminSettingsCollectionName)
          .doc(version)
          .collection("items");

  CollectionReference _adminSettingsCollection() => firestoreParentPathService
      .root()
      .doc("settingsDoc")
      .collection(adminSettingsCollectionName);
}

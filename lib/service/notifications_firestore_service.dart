import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';
import 'package:admin_app/model/notification.dart' as notif;

class NotificationsFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  NotificationsFirestoreService({@required this.firestoreParentPathService});
  static const String notificationsCollectionName = "notifications";

  Future<String> store({@required notif.Notification notification}) async {
    final doc = _notificationsCollection().doc();

    final data = notification.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required notif.Notification notification}) async {
    final doc = _notificationsCollection().doc(notification.id);
    final data = notification.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(data);

    return Future.value(notification.id);
  }

  Future<String> delete({@required String notificationId}) async {
    final doc = _notificationsCollection().doc(notificationId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});

    return Future.value(doc.id);
  }

  Future<notif.Notification> load({@required String notificationId}) async {
    final doc = _notificationsCollection().doc(notificationId);
    final data = await doc.get();

    return Future.value(notif.Notification.fromJson(data.data()));
  }

  Stream<List<notif.Notification>> loadByUser({@required String userId})  {
    return _notificationsCollection().where('destinationUserId', isEqualTo: userId).snapshots().map((event) => event.docs.map((e) => notif.Notification.fromJson(e.data())).toList());
  }

  CollectionReference _notificationsCollection() => firestoreParentPathService.root().doc("${notificationsCollectionName}Doc").collection(notificationsCollectionName);
}

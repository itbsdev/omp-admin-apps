import 'package:flutter/material.dart';
import 'package:admin_app/model/notification.dart' as notif;
import 'package:admin_app/repository/notification/notification_repository.dart';
import 'package:admin_app/service/notifications_firestore_service.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationsFirestoreService notificationsFirestoreService;

  NotificationRepositoryImpl({@required this.notificationsFirestoreService});

  @override
  Future<String> delete({String id}) {
    return notificationsFirestoreService.delete(notificationId: id);
  }

  @override
  Future<String> insert({notif.Notification datum}) {
    return notificationsFirestoreService.store(notification: datum);
  }

  @override
  Future<notif.Notification> load({String id}) {
    return notificationsFirestoreService.load(notificationId: id);
  }

  @override
  Stream<List<notif.Notification>> loadByCompany({String companyId}) {
    throw UnimplementedError("not yet implemented");
  }

  @override
  Future<String> update({notif.Notification datum}) {
    return notificationsFirestoreService.update(notification: datum);
  }

  @override
  Stream<List<notif.Notification>> loadByUser({String userId}) {
    return notificationsFirestoreService.loadByUser(userId: userId);
  }
}

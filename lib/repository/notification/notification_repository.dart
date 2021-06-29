import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/notification.dart';

abstract class NotificationRepository with BaseRepository<Notification> {
  Stream<List<Notification>> loadByUser({String userId});
}

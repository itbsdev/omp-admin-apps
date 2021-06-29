
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/model/user.dart';

abstract class UserRepository with BaseRepository<User> {
  Future<User> getLoggedInUser();

  Stream<List<User>> loadAll();
}

import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/store.dart';

abstract class StoreRepository with BaseRepository<Store> {
  Stream<List<Store>> loadAll();
}


import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/address.dart';

abstract class AddressRepository with BaseRepository<Address> {
  Future<List<Address>> loadByUserId({String userId});

  Stream<List<Address>> loadAll();
}

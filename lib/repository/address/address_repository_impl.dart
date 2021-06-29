import 'package:flutter/material.dart';
import 'package:admin_app/model/address.dart';
import 'package:admin_app/service/address_firestore_service.dart';

import 'address_repository.dart';

class AddressRepositoryImpl extends AddressRepository {
  final AddressFirestoreService addressFirestoreService;

  AddressRepositoryImpl({@required this.addressFirestoreService});

  @override
  Future<String> delete({String id}) {
    return addressFirestoreService.delete(addressId: id);
  }

  @override
  Future<String> insert({Address datum}) {
    return addressFirestoreService.store(address: datum);
  }

  @override
  Future<Address> load({String id}) {
    return addressFirestoreService.load(addressId: id);
  }

  @override
  Stream<List<Address>> loadByCompany({String companyId}) {
    throw UnimplementedError("not yet implemented");
  }

  @override
  Future<String> update({Address datum}) {
    return addressFirestoreService.update(address: datum);
  }

  @override
  Future<List<Address>> loadByUserId({String userId}) {
    return addressFirestoreService.loadByUserId(userId: userId);
  }

  @override
  Stream<List<Address>> loadAll() {
    return addressFirestoreService.loadAll();
  }

}

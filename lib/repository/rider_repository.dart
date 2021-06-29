import 'package:flutter/material.dart';
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/service/rider_firestore_service.dart';
import 'package:admin_app/service/rider_firestore_service.dart';

class RiderRepository with BaseRepository<Rider> {
  final RiderFirestoreService riderFirestoreService;

  const RiderRepository({@required this.riderFirestoreService})
      : assert(riderFirestoreService != null);

  @override
  Future<String> delete({String id}) {
    return riderFirestoreService.delete(riderId: id);
  }

  @override
  Future<String> insert({Rider datum}) {
    return riderFirestoreService.store(rider: datum);
  }

  @override
  Future<Rider> load({String id}) {
    return riderFirestoreService.load(riderId: id);
  }

  @override
  Stream<List<Rider>> loadByCompany({String companyId}) {
    // TODO: implement loadByCompany
    throw UnimplementedError();
  }

  @override
  Future<String> update({Rider datum}) {
    return riderFirestoreService.update(rider: datum);
  }

  Stream<List<Rider>> loadAll() {
    return riderFirestoreService.loadAll();
  }
}

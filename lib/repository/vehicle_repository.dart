import 'package:flutter/material.dart';
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/vehicle.dart';
import 'package:admin_app/service/vehicle_firestore_service.dart';

class VehicleRepository with BaseRepository<Vehicle> {
  final VehicleFirestoreService vehicleFirestoreService;

  const VehicleRepository({@required this.vehicleFirestoreService})
      : assert(vehicleFirestoreService != null);

  @override
  Future<String> delete({String id}) {
    return vehicleFirestoreService.delete(vehicleId: id);
  }

  @override
  Future<String> insert({Vehicle datum}) {
    return vehicleFirestoreService.store(vehicle: datum);
  }

  @override
  Future<Vehicle> load({String id}) {
    return vehicleFirestoreService.load(vehicleId: id);
  }

  @override
  Stream<List<Vehicle>> loadByCompany({String companyId}) {
    // TODO: implement loadByCompany
    throw UnimplementedError();
  }

  Stream<List<Vehicle>> loadByRider({ @required String riderId}) {
    assert(riderId != null);

    return vehicleFirestoreService.loadFromRiderId(riderId: riderId);
  }

  Future<Vehicle> loadInUseByRider({ @required String riderId }) {
    return vehicleFirestoreService.loadInUseByRider(riderId: riderId);
  }

  @override
  Future<String> update({Vehicle datum}) {
    return vehicleFirestoreService.update(vehicle: datum);
  }

  Stream<List<Vehicle>> loadAll() {
    return vehicleFirestoreService.loadAll();
  }
}

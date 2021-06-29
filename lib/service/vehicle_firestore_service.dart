import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/vehicle.dart';

import 'firestore_parent_path_service.dart';

class VehicleFirestoreService {
  final FirestoreParentPathService firestoreParentPathService;

  VehicleFirestoreService({@required this.firestoreParentPathService});

  static const String vehicleCollectionName = "vehicles";

  Future<String> store({@required Vehicle vehicle}) async {
    final doc = _vehiclesCollection().doc();

    final data = vehicle.toJson();
    data["id"] = doc.id;
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.set(data);

    return Future.value(doc.id);
  }

  Future<String> update({@required Vehicle vehicle}) async {
    final doc = _vehiclesCollection().doc(vehicle.id);
    final data = vehicle.toJson();
    data["updatedAt"] = DateTime.now().millisecondsSinceEpoch;

    await doc.update(vehicle.toJson());

    return Future.value(vehicle.id);
  }

  Future<String> delete({@required String vehicleId}) async {
    final doc = _vehiclesCollection().doc(vehicleId);

    // hard delete
//    await doc.delete();
    // soft delete
    await doc.update({"deletedAt": DateTime.now().millisecondsSinceEpoch});
    return Future.value(doc.id);
  }

  Future<Vehicle> load({@required String vehicleId}) async {
    final doc = _vehiclesCollection().doc(vehicleId);
    final data = await doc.get();

    return Future.value(Vehicle.fromJson(data.data()));
  }

  Stream<List<Vehicle>> loadFromRiderId({@required String riderId}) {
    return _vehiclesCollection()
        .where("riderId", isEqualTo: riderId)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Vehicle.fromJson(e.data())).toList());
  }

  Future<Vehicle> loadInUseByRider({@required String riderId}) async {
    final snapshot = await _vehiclesCollection()
        .where("riderId", isEqualTo: riderId)
        .where("inUse", isEqualTo: true)
        .get();

    final vehicles =
        snapshot.docs.map((e) => Vehicle.fromJson(e.data())).toList();

    return vehicles.firstWhere((element) => element.inUse, orElse: () => null);
  }

  Stream<List<Vehicle>> loadAll() {
    return _vehiclesCollection()
        .orderBy("updatedAt", descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Vehicle.fromJson(e.data())).toList());
  }

  CollectionReference _vehiclesCollection() => firestoreParentPathService
      .root()
      .doc("${vehicleCollectionName}Doc")
      .collection(vehicleCollectionName);
}

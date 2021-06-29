import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/location.dart';

class LocationDatabaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Future<void> setLocation({@required Location location}) async {
    assert(location != null);

    await _db
        .reference()
        .child("location/${location.id}")
        .set(location.toJson());

    return Future.value();
  }

  Stream<Location> listenForVehicleLocation({@required String vehicleId}) {
    assert(vehicleId != null && vehicleId.isNotEmpty);

    return _db.reference().child("location/${vehicleId}").onValue.map((event) {
      print("location event: ${event.snapshot.value.toString()}");
      return Location.fromJson(Map.from(event.snapshot.value));
    });
  }
}

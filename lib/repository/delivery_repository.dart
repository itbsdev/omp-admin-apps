import 'package:flutter/material.dart';
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/delivery.dart';
import 'package:admin_app/model/delivery_item.dart';
import 'package:admin_app/model/location.dart';
import 'package:admin_app/service/delivery_firestore_service.dart';
import 'package:admin_app/service/delivery_network_service.dart';
import 'package:admin_app/service/location_database_service.dart';

class DeliveryRepository with BaseRepository<Delivery> {
  final DeliveryFirestoreService deliveryFirestoreService;
  final DeliveryNetworkService deliveryNetworkService;
  final LocationDatabaseService locationDatabaseService;

  const DeliveryRepository(
      {@required this.deliveryFirestoreService,
      @required this.deliveryNetworkService,
      @required this.locationDatabaseService, })
      : assert(deliveryFirestoreService != null),
        assert(deliveryNetworkService != null),
        assert(locationDatabaseService != null);

  @override
  Future<String> delete({String id}) {
    return deliveryFirestoreService.delete(deliveryId: id);
  }

  @override
  Future<String> insert({Delivery datum}) {
    return deliveryFirestoreService.store(delivery: datum);
  }

  @override
  Future<Delivery> load({String id}) {
    return deliveryFirestoreService.load(deliveryId: id);
  }

  @override
  Stream<List<Delivery>> loadByCompany({String companyId}) {
    // TODO: implement loadByCompany
    throw UnimplementedError();
  }

  @override
  Future<String> update({Delivery datum}) {
    return deliveryFirestoreService.update(delivery: datum);
  }

  Stream<Delivery> listenForDeliveryChanges({@required String deliveryId}) {
    return deliveryFirestoreService.listenForDeliveryChanges(
        deliveryId: deliveryId);
  }

  Stream<List<Delivery>> listenForDeliveries() {
    return deliveryFirestoreService.listenForDeliveries();
  }

  Future<void> searchForRider(
      {@required String deliveryId, @required String vehicleType}) {
    return deliveryNetworkService.searchForRider(
        deliveryId: deliveryId, vehicleType: vehicleType);
  }

  Future<List<DeliveryItem>> loadDeliveryItems({@required String deliveryId}) {
    assert(deliveryId != null);

    return deliveryFirestoreService.loadDeliveryItems(deliveryId: deliveryId);
  }

  Stream<Location> listenForVehicleLocation({ @required String vehicleId }) {
    return locationDatabaseService.listenForVehicleLocation(vehicleId: vehicleId);
  }
}

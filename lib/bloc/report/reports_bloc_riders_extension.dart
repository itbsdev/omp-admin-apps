part of 'reports_bloc.dart';

extension RidersReportsBloc on ReportsBloc {
  void _provideRiderJoinGroupings({@required List<Rider> riders}) {
    assert(riders != null);
    List<Rider> filteredRiders = riders;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      filteredRiders = riders
          .where((element) =>
              element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
              element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();
    }

    final groupings = filteredRiders.groupListsBy((element) => _provideFormattedDate(
        date: DateTime.fromMillisecondsSinceEpoch(element.createdAt)));

    add(ProvideRiderJoinGroupingsEvent(mappedRiderJoinGroupings: groupings));
  }

  void _provideDetailedRiderSales(
      {@required List<Rider> riders, List<Delivery> deliveries}) {
    assert(riders != null);
    assert(deliveries != null);
    List<Rider> filteredRiders = riders;
    List<Delivery> filteredDeliveries = deliveries;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      filteredRiders = riders
          .where((element) =>
      element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();

      filteredDeliveries = deliveries
          .where((element) =>
      element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();
    }

    Map<Rider, Map<String, double>> mappedDetailedRiderSales = Map();
    Map<Rider, double> mappedRiderTotalSales = Map();
    Map<String, RiderReports> mappedRiderReports = Map();

    final groupedDeliveriesByRider = filteredDeliveries
        .where((element) => element.riderId != null)
        .groupListsBy((element) => element.riderId);

    groupedDeliveriesByRider.forEach((riderId, inDeliveries) {
      final Map<String, double> mappedRiderSales = Map();
      final Map<String, int> detailedCancellations = Map();
      final Map<String, int> detailedDeliveredOrders = Map();

      final riderTotalSales = inDeliveries.fold(0.0,
          (previousValue, delivery) => previousValue + delivery.totalPayment);
      int totalCancellations = inDeliveries
          .where((element) => element.status == DeliveryStatus.CANCELLED)
          .length;
      int totalDeliveredOrders = inDeliveries
          .where((element) =>
              element.status.index >= DeliveryStatus.ON_THE_WAY.index)
          .length;

      final groupedDeliveriesBySaleDate = inDeliveries.groupListsBy(
          (delivery) => _provideFormattedDate(
              date: DateTime.fromMillisecondsSinceEpoch(delivery.updatedAt)));

      groupedDeliveriesBySaleDate.forEach((dateStr, inDeliveries) {
        mappedRiderSales[dateStr] = inDeliveries
            .where((element) => !noRiderStatus.contains(element.status))
            .fold(
                0.0,
                (previousValue, delivery) =>
                    previousValue + delivery.totalPayment);

        detailedCancellations[dateStr] = inDeliveries
            .where((element) => element.status == DeliveryStatus.CANCELLED)
            .length;

        detailedDeliveredOrders[dateStr] = inDeliveries
            .where((element) =>
                element.status.index >= DeliveryStatus.ON_THE_WAY.index)
            .length;
      });

      final rider = filteredRiders.firstWhere((rider) => rider.id == riderId);
      final reports = RiderReports(
          rider: rider,
          totalSales: riderTotalSales,
          totalCancellations: totalCancellations,
          totalDeliveredOrders: totalDeliveredOrders,
          detailedSales: mappedRiderSales,
          detailedCancellations: detailedCancellations,
          detailedDeliveredOrders: detailedDeliveredOrders);
      mappedDetailedRiderSales[rider] = mappedRiderSales;
      mappedRiderTotalSales[rider] = riderTotalSales;
      mappedRiderReports[rider.id] = reports;
    });

    add(ProvideRiderDetailedSalesEvent(
        mappedRiderTotalSales: mappedRiderTotalSales,
        mappedDetailedRiderSales: mappedDetailedRiderSales,
        mappedRiderReports: mappedRiderReports));
  }

  void _provideDetailedVehicleStatistics({@required List<Vehicle> vehicles}) {
    assert(vehicles != null);

    final vehicleTypeGroupings =
        vehicles.groupListsBy((vehicle) => vehicle.type);

    add(VehicleGroupingEvent(vehicleGroupings: vehicleTypeGroupings));
  }

  void requestForRiderVehicles({@required Rider rider}) async {
    print("requesting for vehicle riders");

    if (_vehicles != null) {
      final filteredVehicles =
          _vehicles.where((vehicle) => vehicle.riderId == rider.id)?.toList();

      if (filteredVehicles != null) {
        add(RequestVehicleForRiderEvent(
            rider: rider, filteredVehicles: filteredVehicles));
      }
    } else {
      print("there are no vehicles in the platform");
    }
  }

  void triggerRiderActivation({@required Rider rider, String deactivationReason}) {
    assert(rider != null);
    assert(_selectedRider != null);

    add(TriggerRiderActivation(rider: _selectedRider, message: deactivationReason));
  }

  Future<void> _activateRider({@required Rider rider}) async {
    assert(rider != null);

    rider.deletedAt = null;
    await riderRepository.update(datum: rider);

    return Future.value();
  }

  Future<void> _deactivateRider({@required Rider rider, String deactivationReason}) async {
    assert(rider != null);
    rider.deletedNote = deactivationReason;
    await riderRepository.update(datum: rider);
    await riderRepository.delete(id: rider.id);

    return Future.value();
  }

  void selectRider({@required Rider rider}) {
    assert(rider != null);

    _selectedRider = rider;
  }
}

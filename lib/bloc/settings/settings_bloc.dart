import 'dart:async';

import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/admin_settings.dart';
import 'package:admin_app/model/settings_item.dart';
import 'package:admin_app/repository/admin_settings_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AdminSettingsRepository adminSettingsRepository;

  SettingsBloc({
    @required this.adminSettingsRepository,
  })  : assert(adminSettingsRepository != null),
        super(SettingsInitial()) {
    loadLatest();
  }

  AdminSettings _latestAdminSettings;

  AdminSettings get latestAdminSettings => _latestAdminSettings;

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    try {
      if (event is LatestAdminSettingsLoadedEvent) {
        _latestAdminSettings = event.settings;

        yield LatestAdminSettingsLoadedState(settings: event.settings);
      } else if (event is SettingsErrorEvent) {
        yield SettingsErrorState(message: event.message);
      } else if (event is SaveAdminSettingsEvent) {
        await adminSettingsRepository.insert(datum: event.settings);
        loadLatest();
        yield SettingsSuccessState(message: "Successfully saved settings");
      }
    } catch (err) {
      print(
          "SettingsBloc -- Something went wrong while performing $event: ${err.toString()}");
      yield SettingsErrorState(
          message:
              "Something went wrong while performing $event: ${err.toString()}");
    }
  }

  // public methods

  void saveAdminSettings(
      {@required String baseOrderDeliveryCharge,
      @required String weight,
      @required String pricePerWeight,
      @required String volume,
      @required String pricePerVolume,
      @required String baseDeliveryDeliveryCharge,
      @required String distance,
      @required String pricePerDistance,
      @required String bikeCharge,
      @required String motorcycleCharge,
      @required String sedanCharge,
      @required String auvCharge,
      @required String pickupCharge,
      @required String suvCharge,
      @required String truckCharge}) {
    final List<SettingsItem> items = [];

    if (baseOrderDeliveryCharge == null || baseOrderDeliveryCharge.isEmpty) {
      add(SettingsErrorEvent(message: "baseOrderDeliveryCharge is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.BASE_ORDER_DELIVERY_CHARGE,
          value: num.tryParse(baseOrderDeliveryCharge)));
    }

    if (weight == null || weight.isEmpty) {
      add(SettingsErrorEvent(message: "Weight is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.WEIGHT, value: num.tryParse(weight)));
    }

    if (pricePerWeight == null || pricePerWeight.isEmpty) {
      add(SettingsErrorEvent(message: "Price per weight is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.PRICE_PER_WEIGHT,
          value: num.tryParse(pricePerWeight)));
    }

    if (volume == null || volume.isEmpty) {
      add(SettingsErrorEvent(message: "Volume is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.VOLUME, value: num.tryParse(volume)));
    }

    if (pricePerVolume == null || pricePerVolume.isEmpty) {
      add(SettingsErrorEvent(message: "Price per volume is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.PRICE_PER_VOLUME,
          value: num.tryParse(pricePerVolume)));
    }

    if (baseDeliveryDeliveryCharge == null || baseDeliveryDeliveryCharge.isEmpty) {
      add(SettingsErrorEvent(
          message: "Base delivery charge is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.BASE_DELIVERY_CHARGE,
          value: num.tryParse(baseDeliveryDeliveryCharge)));
    }

    if (distance == null || distance.isEmpty) {
      add(SettingsErrorEvent(message: "Distance is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.DISTANCE,
          value: num.tryParse(distance)));
    }

    if (pricePerDistance == null || pricePerDistance.isEmpty) {
      add(SettingsErrorEvent(message: "Price per distance is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.PRICE_PER_DISTANCE,
          value: num.tryParse(pricePerDistance)));
    }

    if (bikeCharge == null || bikeCharge.isEmpty) {
      add(SettingsErrorEvent(message: "Bike charge is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.BIKE_CHARGE,
          value: num.tryParse(bikeCharge)));
    }

    if (motorcycleCharge == null || motorcycleCharge.isEmpty) {
      add(SettingsErrorEvent(message: "Motorcycle charge is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.MOTORCYCLE_CHARGE,
          value: num.tryParse(motorcycleCharge)));
    }

    if (sedanCharge == null || sedanCharge.isEmpty) {
      add(SettingsErrorEvent(message: "Sedan charge is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.SEDAN_CHARGE,
          value: num.tryParse(sedanCharge)));
    }

    if (auvCharge == null || auvCharge.isEmpty) {
      add(SettingsErrorEvent(message: "AUV charge is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.AUV_CHARGE,
          value: num.tryParse(auvCharge)));
    }

    if (pickupCharge == null || pickupCharge.isEmpty) {
      add(SettingsErrorEvent(message: "Pickup charge is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.PICKUP_CHARGE,
          value: num.tryParse(pickupCharge)));
    }

    if (suvCharge == null || suvCharge.isEmpty) {
      add(SettingsErrorEvent(message: "SUV charge is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.SUV_CHARGE,
          value: num.tryParse(suvCharge)));
    }

    if (truckCharge == null || truckCharge.isEmpty) {
      add(SettingsErrorEvent(message: "Truck charge is required"));
      return;
    } else {
      items.add(SettingsItem(
          name: AdminSettingsItemFields.TRUCK_CHARGE,
          value: num.tryParse(truckCharge)));
    }

    String version = "v${DateTime.now().toIso8601String()}";

    final AdminSettings settings = AdminSettings(
        version: version, createdBy: "admin", createdAt: DateTime.now().millisecondsSinceEpoch);
    settings.items = items;

    add(SaveAdminSettingsEvent(settings: settings));
  }

  // private methods

  void loadLatest() async {
    final adminSettings = await adminSettingsRepository.loadLatest();

    add(LatestAdminSettingsLoadedEvent(settings: adminSettings));
  }
}

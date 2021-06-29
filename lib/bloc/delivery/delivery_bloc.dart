import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/delivery.dart';
import 'package:admin_app/model/delivery_item.dart';
import 'package:admin_app/model/delivery_rider.dart';
import 'package:admin_app/model/location.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/model/user.dart';
import 'package:admin_app/model/vehicle.dart';
import 'package:admin_app/repository/address/address_repository.dart';
import 'package:admin_app/repository/delivery_repository.dart';
import 'package:admin_app/repository/order/order_repository.dart';
import 'package:admin_app/repository/product/product_repository.dart';
import 'package:admin_app/repository/rider_repository.dart';
import 'package:admin_app/repository/user/user_repository.dart';
import 'package:admin_app/repository/vehicle_repository.dart';

part 'delivery_event.dart';

part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final DeliveryRepository deliveryRepository;
  final AddressRepository addressRepository;
  final UserRepository userRepository;
  final OrderRepository orderRepository;
  final RiderRepository riderRepository;
  final VehicleRepository vehicleRepository;
  final ProductRepository productRepository;

  DeliveryBloc(
      {@required this.deliveryRepository,
      @required this.addressRepository,
      @required this.userRepository,
      @required this.orderRepository,
      @required this.riderRepository,
      @required this.vehicleRepository,
      @required this.productRepository})
      : assert(deliveryRepository != null),
        assert(userRepository != null),
        assert(addressRepository != null),
        assert(orderRepository != null),
        assert(riderRepository != null),
        assert(vehicleRepository != null),
        assert(productRepository != null),
        super(DeliveryInitial()) {
    _listenForDeliveries();
  }

  Timer _timerLink;
  int _timerLimit = 60;

  VehicleType _vehicleTypeSelected;

  VehicleType get vehicleTypeSelected => _vehicleTypeSelected;

  DeliveryRider _selectedDelivery;

  DeliveryRider get selectedDelivery => _selectedDelivery;

  String _currentDeliveryIdProcessing;

  bool _isPickedUp;

  bool get isPickedUp => _isPickedUp ?? false;

  StreamSubscription<Delivery> _currentDeliveryStream;

  StreamSubscription<Location> _currentVehicleLocationStream;

  List<DeliveryRider> _deliveries;

  List<DeliveryRider> get deliveries => _deliveries ?? [];

  @override
  Stream<DeliveryState> mapEventToState(
    DeliveryEvent event,
  ) async* {
    try {
      if (event is DeliveriesRetrievedEvent) {
        if (_deliveries == null) _deliveries = List();

        _deliveries.clear();

        _deliveries.addAll(event.deliveries);

        yield DeliveriesRetrievedState(deliveries: event.deliveries);
      } else if (event is RequestDeliveryErrorEvent) {
        if (_timerLink != null) _timerLink.cancel();

        await _cancelDeliveryStream();

        yield RequestDeliveryErrorState(err: event.err);
      } else if (event is RequestDeliveryProgressEvent) {
        yield RequestDeliveryProgressState(
            formattedProgress: "0:${_timerLimit - event.progress}");
      } else if (event is RequestDeliverySuccessEvent) {
        if (_timerLink != null) _timerLink.cancel();

        final delivery = event.data as Delivery;
        final rider = await riderRepository.load(id: delivery.riderId);
        final userRider = await userRepository.load(id: rider.userId);
        final vehicle = await vehicleRepository.load(id: delivery.vehicleId);

        _selectedDelivery = DeliveryRider(
            delivery: delivery, rider: userRider, vehicle: vehicle);

        yield RequestDeliverySuccessState();

        await Future.delayed(Duration(milliseconds: 2000));

        yield NavigateToCurrentDeliveryScreenState();
      } else if (event is DeliverySuccessEvent) {
        await _cancelDeliveryStream(includeUpdateDelivery: false);
        yield DeliverySuccessState(
            data: event.data, message: "Successfully fulfilled delivery");
      } else if (event is VehicleTypeSelectedEvent) {
        _vehicleTypeSelected = event.vehicleType;

        yield VehicleTypeSelectedState(vehicleType: event.vehicleType);
      } else if (event is CallRiderEvent) {
        yield CallRiderState(rider: event.rider);
      } else if (event is SmsRiderEvent) {
        yield SmsRiderState(rider: event.rider);
      } else if (event is VehicleCurrentLocationEvent) {
        yield ShowLocationToMapState(
            latitude: event.latitude, longitude: event.longitude);
      } else if (event is DeliveryRetrievedEvent) {
        _selectedDelivery = event.deliveryRider;
        yield DeliveryRetrievedState(deliveryRider: event.deliveryRider);
      }
    } catch (err) {
      print("DeliveryBloc -- something went wrong: ${err.toString()}");
      yield DeliveryErrorState(err: err.toString());
    }
  }

  void triggerRiderSearch({@required Order order}) {
    assert(order != null);

    add(RequestDeliveryEvent(order: order));
  }

  void triggerRiderSearchCancel() {
    add(RequestDeliveryErrorEvent(err: "Cancel rider search"));
  }

  void triggerCancelDelivery() {
    add(RequestDeliveryErrorEvent(err: "Delivery cancelled"));
  }

  void _triggerRiderTimeOut() {
    add(RequestDeliveryErrorEvent(err: "rider time out"));
  }

  void _triggerProgress(int progress) {
    add(RequestDeliveryProgressEvent(progress: progress));
  }

  void _triggerRiderSearchSuccess(Delivery delivery) {
    add(RequestDeliverySuccessEvent(data: delivery));
  }

  void triggerCall() {
    if (_selectedDelivery != null) {
      add(CallRiderEvent(rider: _selectedDelivery.rider));
    }
  }

  void triggerSms() {
    if (_selectedDelivery != null) {
      add(SmsRiderEvent(rider: _selectedDelivery.rider));
    }
  }

  void _listenForDeliveries() async {
    final userStoreMap = await userRepository.getLoggedInUser();

    deliveryRepository
        .listenForDeliveries()
        .listen((event) async {
      final list = [];
      for (var delivery in event) {
        final items =
            await deliveryRepository.loadDeliveryItems(deliveryId: delivery.id);
        final itemsMap = items.map((e) async {
          if (e.itemId != null) {
            final product = await productRepository.load(id: e.itemId);
            e.itemPhoto = product.imageUrls.first;
          }

          return e;
        });

        delivery.items = await Future.wait(itemsMap);

        User rider;
        Vehicle vehicle;
        Product product;
        Order order;
        User customer;

        if (delivery.riderId != null) {
          final riderTmp = await riderRepository.load(id: delivery.riderId);
          rider = await userRepository.load(id: riderTmp.userId);

          if (delivery.vehicleId != null) {
            vehicle = await vehicleRepository.load(id: delivery.vehicleId);
          }
        }

        if (delivery.type == RiderServiceType.ORDER) {
          if (delivery.items.isNotEmpty) {
            final item = delivery.items.first;

            if (item != null) {
              product = await productRepository.load(id: item.itemId);
              order = await orderRepository.load(id: item.typeId);
              customer = await userRepository.load(id: order.customerId);
            }
          }
        }

        list.add(
            DeliveryRider(delivery: delivery,
                rider: rider,
                vehicle: vehicle,
            product: product,
            order: order,
            customer: customer));
      }

      add(DeliveriesRetrievedEvent(deliveries: list));
    });
  }

  void _listenForDeliveryChanges(String deliveryId) async {
    _currentDeliveryStream = deliveryRepository
        .listenForDeliveryChanges(deliveryId: deliveryId)
        .listen((event) async {
      if (event.id == _currentDeliveryIdProcessing) {
        print("listened: updates from $deliveryId");
        Rider rider;

        if (event.riderId != null) {
          rider = await riderRepository.load(id: event.riderId);
          final userRider = await userRepository.load(id: rider.userId);
          final vehicle = await vehicleRepository.load(id: event.vehicleId);
          final items =
          await deliveryRepository.loadDeliveryItems(deliveryId: event.id);

          event.items = items;

          _selectedDelivery =
              DeliveryRider(delivery: event, rider: userRider, vehicle: vehicle);

          add(DeliveryRetrievedEvent(deliveryRider: _selectedDelivery));
        }

        if (event.status == DeliveryStatus.ACCEPTED) {
          _triggerRiderSearchSuccess(event);
        } else if (event.status == DeliveryStatus.COMPLETED) {
          _triggerDeliverySuccess(event);
        }

        if (event.vehicleId != null) {
          _listenToVehicleLocation(vehicleId: event.vehicleId);
        }
      }
    });
  }

  void _listenToVehicleLocation({@required String vehicleId}) {
    assert(vehicleId != null && vehicleId.isNotEmpty);

    _currentVehicleLocationStream = deliveryRepository
        .listenForVehicleLocation(vehicleId: vehicleId)
        .listen((event) {
      add(VehicleCurrentLocationEvent(
          latitude: event.latitude, longitude: event.longitude));
    });
  }

  Future<void> _cancelDeliveryStream({ bool includeUpdateDelivery = true}) async {
    if (_currentDeliveryStream != null) {
      await _currentDeliveryStream.cancel();

      if (includeUpdateDelivery) {
        final delivery =
        await deliveryRepository.load(id: _currentDeliveryIdProcessing);

        delivery.status = DeliveryStatus.CANCELLED;
        await deliveryRepository.update(datum: delivery);
      }

      resetStream();
    }
  }

  void resetStream() {
    _currentDeliveryStream = null;
    _currentDeliveryIdProcessing = null;
    _currentVehicleLocationStream = null;
  }

  void _triggerDeliverySuccess(Delivery delivery) {
    add(DeliverySuccessEvent(data: delivery));
  }

  void selectVehicleType(VehicleType type) {
    add(VehicleTypeSelectedEvent(vehicleType: type));
  }

  num totalOrderAmount() {
    if (_selectedDelivery == null) return 0;

    return 0;
  }

  void selectDelivery({@required DeliveryRider deliveryRider}) {
    assert(deliveryRider != null);

    _selectedDelivery = deliveryRider;

    _currentDeliveryIdProcessing = deliveryRider.delivery.id;
    _listenForDeliveryChanges(_currentDeliveryIdProcessing);

    final vehicleId = deliveryRider.delivery.vehicleId;

    if (vehicleId != null) {
      _listenToVehicleLocation(vehicleId: deliveryRider.delivery.vehicleId);
    }
  }
}

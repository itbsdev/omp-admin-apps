import 'dart:async';
import 'dart:collection';

import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/address.dart';
import 'package:admin_app/model/delivery.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/model/rider_reports.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/model/store_reports.dart';
import 'package:admin_app/model/user.dart';
import 'package:admin_app/model/vehicle.dart';
import 'package:admin_app/repository/address/address_repository.dart';
import 'package:admin_app/repository/delivery_repository.dart';
import 'package:admin_app/repository/order/order_repository.dart';
import 'package:admin_app/repository/product/product_repository.dart';
import 'package:admin_app/repository/rider_repository.dart';
import 'package:admin_app/repository/store/store_repository.dart';
import 'package:admin_app/repository/user/user_repository.dart';
import 'package:admin_app/repository/vehicle_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';

part 'reports_event.dart';

part 'reports_state.dart';

part 'reports_bloc_orders_extension.dart';

part 'reports_bloc_stores_extension.dart';

part 'reports_bloc_riders_extension.dart';

part 'reports_bloc_deliveries_extension.dart';

part 'reports_bloc_users_extension.dart';

/// reports will consist of:
/// * number of users -- ok
/// * number of stores -- ok
/// * number of riders who are the users that are stores at the same time riders
/// * number of products registered in the platform
/// * number of vehicles -- ok
/// * sales numbers -- ok
/// * filters by date for sales
/// * delivery numbers -- how many deliveries happened in the application
/// * filters by date for deliveries
/// * stores with most sales
/// * most sale product
///
///
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final UserRepository userRepository;
  final AddressRepository addressRepository;
  final ProductRepository productRepository;
  final DeliveryRepository deliveryRepository;
  final OrderRepository orderRepository;
  final VehicleRepository vehicleRepository;
  final StoreRepository storeRepository;
  final RiderRepository riderRepository;

  ReportsBloc({
    @required this.userRepository,
    @required this.addressRepository,
    @required this.productRepository,
    @required this.deliveryRepository,
    @required this.orderRepository,
    @required this.vehicleRepository,
    @required this.storeRepository,
    @required this.riderRepository,
  })  : assert(userRepository != null),
        assert(addressRepository != null),
        assert(productRepository != null),
        assert(deliveryRepository != null),
        assert(orderRepository != null),
        assert(vehicleRepository != null),
        assert(storeRepository != null),
        assert(riderRepository != null),
        super(ReportsInitial()) {
    _getAddresses();
    _getUsers();
    _getStores();
    _getProducts();
    _getRiders();
    _getVehicles();
    _getOrders();
    _getDeliveries();
  }

  double _totalSalesToDate;

  List<Delivery> _deliveries;

  List<Delivery> get deliveries => _deliveries ?? [];

  List<Order> _orders;

  List<Order> get orders => _orders ?? [];

  List<Vehicle> _vehicles;

  List<Vehicle> get vehicles => _vehicles ?? [];

  List<Product> _products;

  List<Product> get products => _products ?? [];

  List<Rider> _riders;

  List<Rider> get riders => _riders ?? [];

  List<User> _users;

  List<User> get users => _users ?? [];

  List<Store> _stores;

  List<Store> get stores => _stores ?? [];

  List<Address> _addresses;

  List<Address> get addresses => _addresses ?? [];

  Map<String, double> _orderDailySales;

  Map<String, double> get orderDailySales =>
      _orderDailySales == null ? Map() : _orderDailySales;

  Map<String, double> _deliveryDailySales;

  Map<String, double> get deliveryDailySales => _deliveryDailySales ?? Map();

  Map<String, double> _combinedDailySales;

  Map<String, double> get combinedDailySales => _combinedDailySales ?? Map();

  // selected filters
  DateTime _selectedStartDate;

  DateTime get selectedStartDate => _selectedStartDate;

  DateTime _selectedEndDate;

  DateTime get selectedEndDate => _selectedEndDate;

  DateGrouping _selectedDateGrouping;

  DateGrouping get selectedDateGrouping =>
      _selectedDateGrouping ?? DateGrouping.DAILY; // daily is the default

  // store dashboard
  /// group stores by join dates.
  /// grouping is based on _selectedDateGrouping;
  Map<String, List<Store>> _mappedStoreJoinDate;

  Map<String, List<Store>> get mappedStoreJoinDate =>
      _mappedStoreJoinDate ?? Map();

  Map<Store, Map<String, double>> _mappedStoreDetailedSales;

  Map<Store, Map<String, double>> get mappedStoreDetailedSales =>
      _mappedStoreDetailedSales ?? Map();

  Map<Store, double> _mappedStoreTotalSales;

  Map<Store, double> get mappedStoreTotalSales =>
      _mappedStoreTotalSales ?? Map();

  Map<String, StoreReports> _mappedDetailedStoreReports;

  Map<String, StoreReports> get mappedDetailedStoreReports =>
      _mappedDetailedStoreReports ?? Map();

  Store _selectedStore;

  Store get selectedStore => _selectedStore;

  // rider dashboard
  /// group rider by join dates.
  /// grouping is based on _selectedDateGrouping;
  Map<String, List<Rider>> _mappedRiderJoinGroupings;

  Map<String, List<Rider>> get mappedRiderJoinGroupings =>
      _mappedRiderJoinGroupings ?? Map();

  Map<Rider, Map<String, double>> _mappedRiderDetailedSales;

  Map<Rider, Map<String, double>> get mappedRiderDetailedSales =>
      _mappedRiderDetailedSales ?? Map();

  Map<Rider, double> _mappedRiderTotalSales;

  Map<Rider, double> get mappedRiderTotalSales =>
      _mappedRiderTotalSales ?? Map();

  Map<VehicleType, List<Vehicle>> _mappedVehicleGroupings;

  Map<VehicleType, List<Vehicle>> get mappedVehicleGroupings =>
      _mappedVehicleGroupings ?? Map();

  Map<String, List<Vehicle>> _mappedVehiclesByRider;

  Map<String, RiderReports> _mappedRiderReports;

  Map<String, RiderReports> get mappedRiderReports =>
      _mappedRiderReports ?? Map();

  // User dashboard
  Map<Gender, List<User>> _mappedUserGroupedByGender;

  Map<Gender, List<User>> get mappedUserGroupedByGender =>
      _mappedUserGroupedByGender ?? Map();

  Map<String, List<User>> _mappedUserGroupedByMerchantRider;

  Map<String, List<User>> get mappedUserGroupedByMerchantRider =>
      _mappedUserGroupedByMerchantRider ?? Map();

  Map<String, List<User>> _mappedUserGroupedByAge;

  Map<String, List<User>> get mappedUserGroupedByAge =>
      _mappedUserGroupedByAge ?? Map();

  Rider _selectedRider;

  Rider get selectedRider => _selectedRider;

  @override
  void onTransition(Transition<ReportsEvent, ReportsState> transition) {
    // print(transition.toString());
  }

  @override
  Stream<ReportsState> mapEventToState(
    ReportsEvent event,
  ) async* {
    try {
      if (event is UsersRetrievedEvent) {
        if (_users == null) _users = [];

        _users?.clear();
        _users?.addAll(event.users.where((element) => element.name != null));

        _provideUserAgeGroupings(users: _users);
        _provideUserGenderGrouping(users: _users);

        if (_users != null && _riders != null && _stores != null) {
          _provideUserMerchantRiderGroupings(
              users: _users, riders: _riders, stores: _stores);
        }

        yield (ReportsSuccessState(
            data: _users, message: "successfully retrieved users"));
      } else if (event is StoresRetrievedEvent) {
        if (_stores == null) _stores = [];

        _stores?.clear();
        _stores?.addAll(event.stores);

        if (_users != null && _riders != null && _stores != null) {
          _provideUserMerchantRiderGroupings(
              users: _users, riders: _riders, stores: _stores);
        }

        yield (ReportsSuccessState(
            data: _stores, message: "successfully retrieved stores"));

        if (_stores != null && _orders != null) {
          _provideDetailedStoresSales(orders: _orders, stores: _stores);
        }
      } else if (event is ProductsRetrievedEvent) {
        if (_products == null) _products = [];

        _products?.clear();
        _products.addAll(event.products);
        yield (ReportsSuccessState(
            data: _products, message: "successfully retrieved products"));
      } else if (event is OrdersRetrievedEvent) {
        if (_orders == null) _orders = [];

        _orders?.clear();
        _orders?.addAll(event.orders);

        _parseOrdersForDashboard(event.orders);
        yield (ReportsSuccessState(
            data: _orders, message: "successfully retrieved orders"));

        if (_stores != null && _orders != null) {
          _provideDetailedStoresSales(orders: _orders, stores: _stores);
        }
      } else if (event is OrderDashboardDataEvent) {
        _orderDailySales = event.dailySales;
        yield ReportsSuccessState(
            message: "Successfully computed order dashboard");

        if (_orderDailySales != null && _deliveryDailySales != null) {
          _combineDailySales(
              orderSales: _orderDailySales, deliverySales: _deliveryDailySales);
        }
      } else if (event is DeliveriesRetrievedEvent) {
        if (_deliveries == null) _deliveries = [];

        _deliveries?.clear();
        _deliveries?.addAll(event.deliveries);

        _parseDeliveriesForDashboard(deliveries: _deliveries);

        if (_riders != null && _deliveries != null) {
          _provideDetailedRiderSales(riders: _riders, deliveries: _deliveries);
        }
        yield (ReportsSuccessState(
            data: _deliveries, message: "successfully retrieved deliveries"));
      } else if (event is RidersRetrievedEvent) {
        if (_riders == null) _riders = [];

        _riders?.clear();
        _riders?.addAll(event.riders);

        if (_users != null && _riders != null && _stores != null) {
          _provideUserMerchantRiderGroupings(
              users: _users, riders: _riders, stores: _stores);
        }

        _provideRiderJoinGroupings(riders: _riders);

        if (_riders != null && _deliveries != null) {
          _provideDetailedRiderSales(riders: _riders, deliveries: _deliveries);
        }
        yield (ReportsSuccessState(
            data: _riders, message: "successfully retrieved riders"));
      } else if (event is VehiclesRetrievedEvent) {
        if (_vehicles == null) _vehicles = [];

        _vehicles?.clear();
        _vehicles?.addAll(event.vehicles);

        _provideDetailedVehicleStatistics(vehicles: _vehicles);
        yield (ReportsSuccessState(
            data: _vehicles, message: "successfully retrieved Vehicles"));
      } else if (event is AddressesRetrievedEvent) {
        _addresses = event.addresses;

        yield ReportsSuccessState(
            data: event.addresses, message: "Successfully retrieved addresses");
      } else if (event is DateFilterSelectedEvent) {
        _selectedStartDate = event.startDate;
        _selectedEndDate = event.endDate;

        yield DateFilterSelectedState(
            startDate: _selectedStartDate, endDate: _selectedEndDate);

        _refresh();
      } else if (event is DateGroupingSelectedEvent) {
        _selectedDateGrouping = event.grouping;

        yield DateGroupingSelectedState(grouping: _selectedDateGrouping);

        _refresh();
      } else if (event is ProvideStoreJoinGroupingEvent) {
        _mappedStoreJoinDate = event.mappedStoreJoinDate;
        yield ProvideStoreJoinGroupingState(
            mappedStoreJoinDate: event.mappedStoreJoinDate);
      } else if (event is ProvideDetailedStoresSalesEvent) {
        _mappedStoreDetailedSales = event.mapDetailedStoreSales;
        _mappedStoreTotalSales = event.mapStoreTotalSales;
        _mappedDetailedStoreReports = event.mappedStoreReports;
        yield ProvideDetailedStoresSalesState(
            mapDetailedStoreSales: event.mapDetailedStoreSales,
            mapStoreTotalSales: event.mapStoreTotalSales);
      } else if (event is DeliveriesDashboardDataEvent) {
        _deliveryDailySales = event.mappedDeliveryTotalSales;
        yield DeliveriesDashboardDataState(
            mappedDeliveryTotalSales: event.mappedDeliveryTotalSales);
        if (_orderDailySales != null && _deliveryDailySales != null) {
          _combineDailySales(
              orderSales: _orderDailySales, deliverySales: _deliveryDailySales);
        }
      } else if (event is ProvideRiderJoinGroupingsEvent) {
        _mappedRiderJoinGroupings = event.mappedRiderJoinGroupings;
        yield ProvideRiderJoinGroupingsState(
            mappedRiderJoinGroupings: _mappedRiderJoinGroupings);
      } else if (event is ProvideRiderDetailedSalesEvent) {
        _mappedRiderDetailedSales = event.mappedDetailedRiderSales;
        _mappedRiderTotalSales = event.mappedRiderTotalSales;
        _mappedRiderReports = event.mappedRiderReports;

        yield ProvideRiderDetailedSalesState(
            mappedRiderTotalSales: _mappedRiderTotalSales,
            mappedDetailedRiderSales: _mappedRiderDetailedSales);
      } else if (event is VehicleGroupingEvent) {
        _mappedVehicleGroupings = event.vehicleGroupings;

        yield VehicleGroupingState(vehicleGroupings: event.vehicleGroupings);
      } else if (event is RequestVehicleForRiderEvent) {
        if (_mappedVehiclesByRider == null) _mappedVehiclesByRider = Map();

        _mappedVehiclesByRider[event.rider.id] = event.filteredVehicles;
        yield RequestVehicleForRiderState(
            rider: event.rider, filteredVehicles: event.filteredVehicles);
      } else if (event is UserGroupedByAgeEvent) {
        _mappedUserGroupedByAge = event.userGroupedByAge;

        yield UserGroupedByAgeState(userGroupedByAge: event.userGroupedByAge);
      } else if (event is UserGroupedByMerchantRiderEvent) {
        if (_mappedUserGroupedByMerchantRider == null)
          _mappedUserGroupedByMerchantRider = Map();

        _mappedUserGroupedByMerchantRider["Merchant"] = event.storeOwners;
        _mappedUserGroupedByMerchantRider["Rider"] = event.riderOwners;
        yield UserGroupedByMerchantRiderState(
            storeOwners: event.storeOwners, riderOwners: event.riderOwners);
      } else if (event is UserGroupedByGenderEvent) {
        _mappedUserGroupedByGender = event.userGroupedGender;

        yield UserGroupedByGenderState(
            userGroupedGender: event.userGroupedGender);
      } else if (event is ClearDateFilterEvent) {
        _selectedStartDate = null;
        _selectedEndDate = null;
        yield ReportsSuccessState(message: "Successfully cleared date");

        _refresh();
      } else if (event is CombinedSalesEvent) {
        _combinedDailySales = event.combinedSales;
        yield ReportsSuccessState(
            data: event.combinedSales,
            message: "successfully computed combined sales");
      } else if (event is TriggerStoreActivation) {
        yield ReportsLoadingState(show: true);
        final tmpStore = event.store;

        if (tmpStore.deletedAt != null) {
          tmpStore.deletedAt = null;
          _selectedStore = tmpStore;
          await _activateStore(store: tmpStore);
          final tmpStore2 =
              _stores.firstWhereOrNull((element) => element.id == tmpStore.id);

          if (tmpStore2 != null) {
            _stores.remove(tmpStore2);
            _stores.add(tmpStore);
            _stores.sortBy((element) => element.name);
          }
        } else {
          tmpStore.deletedAt = DateTime.now().millisecondsSinceEpoch;
          _selectedStore = tmpStore;
          await _deactivateStore(store: tmpStore, deactivationReason: event.message);
          final tmpStore2 =
          _stores.firstWhereOrNull((element) => element.id == tmpStore.id);

          if (tmpStore2 != null) {
            _stores.remove(tmpStore2);
            _stores.add(tmpStore);
            _stores.sortBy((element) => element.name);
          }
        }

        yield ReportsLoadingState(show: false);
        yield ReportsSuccessState(
            message: "successfully triggered store activation");
      } else if (event is TriggerRiderActivation) {
        yield ReportsLoadingState(show: true);
        final tmpRider = event.rider;

        if (tmpRider.deletedAt != null) {
          tmpRider.deletedAt = null;
          _selectedRider = tmpRider;
          await _activateRider(rider: tmpRider);
        } else {
          tmpRider.deletedAt = DateTime.now().millisecondsSinceEpoch;
          _selectedRider = tmpRider;
          await _deactivateRider(rider: tmpRider, deactivationReason: event.message);
        }

        yield ReportsLoadingState(show: false);
        yield ReportsSuccessState(
            message: "Successfully updated rider activation");
      }
    } catch (err) {
      print(
          "reportsBloc: something went wrong while performing reports: ${err.toString()}. event: ${event.toString()}");
      yield ReportsLoadingState(show: false);
      yield ReportsErrorState(errorMessage: err.toString());
    }
  }

  void setSelectedDates({DateTime start, DateTime end}) {
    assert(start != null);
    assert(end != null);

    add(DateFilterSelectedEvent(startDate: start, endDate: end));
  }

  void clearDates() {
    add(ClearDateFilterEvent());
  }

  void setDateGrouping({DateGrouping grouping = DateGrouping.DAILY}) {
    assert(grouping != null);

    add(DateGroupingSelectedEvent(grouping: grouping));
  }

  List<Vehicle> getVehiclesByRider({@required Rider rider}) {
    assert(rider != null);

    if (_mappedVehiclesByRider == null) return [];

    return _mappedVehiclesByRider[rider.id];
  }

  double calculateCombinedTotalSales() {
    double orderSales = 0.0;
    double deliverySales = 0.0;

    if (_orderDailySales != null) {
      final totalComputedOrderSales = _orderDailySales.values
          .fold(0.0, (double previousValue, sale) => previousValue + sale);

      if (totalComputedOrderSales != null) {
        orderSales = totalComputedOrderSales;
      }
    }

    if (_deliveryDailySales != null) {
      final totalComputedRiderSales = _deliveryDailySales.values
          .fold(0.0, (double previousValue, sale) => previousValue + sale);

      if (totalComputedRiderSales != null) {
        deliverySales = totalComputedRiderSales;
      }
    }

    return orderSales + deliverySales;
  }

  double calculateAllStoreSales() {
    double orderSales = 0.0;

    if (_orderDailySales != null) {
      final totalComputedOrderSales = _orderDailySales.values
          .fold(0.0, (double previousValue, sale) => previousValue + sale);

      if (totalComputedOrderSales != null) {
        orderSales = totalComputedOrderSales;
      }
    }

    return orderSales;
  }

  double calculateAllRiderSales() {
    double deliverySales = 0.0;

    if (_deliveryDailySales != null) {
      final totalComputedRiderSales = _deliveryDailySales.values
          .fold(0.0, (double previousValue, sale) => previousValue + sale);

      if (totalComputedRiderSales != null) {
        deliverySales = totalComputedRiderSales;
      }
    }

    return deliverySales;
  }

  double calculateCombinedTotalSales2() {
    return calculateAllStoreSales() + calculateAllRiderSales();
  }

  /// --- PRIVATE FUNCTIONS --- ///

  void _getUsers() async {
    userRepository.loadAll().listen((event) {
      add(UsersRetrievedEvent(users: event));
    });
  }

  void _getStores() {
    storeRepository.loadAll().listen((event) {
      add(StoresRetrievedEvent(stores: event));
    });
  }

  void _getProducts() {
    productRepository.loadAll().listen((event) {
      add(ProductsRetrievedEvent(products: event));
    });
  }

  void _getOrders() {
    orderRepository.loadAll().listen((event) {
      add(OrdersRetrievedEvent(orders: event));
    });
  }

  void _getDeliveries() {
    deliveryRepository.listenForDeliveries().listen((event) {
      add(DeliveriesRetrievedEvent(deliveries: event));
    });
  }

  void _getRiders() {
    riderRepository.loadAll().listen((event) {
      add(RidersRetrievedEvent(riders: event));
    });
  }

  void _getVehicles() {
    vehicleRepository.loadAll().listen((event) {
      add(VehiclesRetrievedEvent(vehicles: event));
    });
  }

  void _getAddresses() {
    addressRepository.loadAll().listen((event) {
      add(AddressesRetrievedEvent(addresses: event));
    });
  }

  void _refresh() {
    if (_users != null) add(UsersRetrievedEvent(users: List.from(_users)));

    if (_stores != null) add(StoresRetrievedEvent(stores: List.from(_stores)));

    if (_addresses != null)
      add(AddressesRetrievedEvent(addresses: List.from(_addresses)));

    if (_vehicles != null)
      add(VehiclesRetrievedEvent(vehicles: List.from(_vehicles)));

    if (_riders != null) add(RidersRetrievedEvent(riders: List.from(_riders)));

    if (_products != null)
      add(ProductsRetrievedEvent(products: List.from(_products)));

    if (_deliveries != null)
      add(DeliveriesRetrievedEvent(deliveries: List.from(_deliveries)));

    if (_orders != null) add(OrdersRetrievedEvent(orders: List.from(_orders)));
  }

  void _combineDailySales(
      {@required Map<String, double> orderSales,
      @required Map<String, double> deliverySales}) {
    assert(orderSales != null);
    assert(deliverySales != null);

    Map<String, double> combinedSales = Map();

    orderSales.forEach((key, value) {
      final double deliveryValue = deliverySales[key] ?? 0.0;

      combinedSales[key] = deliveryValue + value;
    });

    deliverySales.forEach((key, value) {
      final double fromCombinedValue = combinedSales[key];

      if (fromCombinedValue == null) {
        combinedSales[key] = value;
      }
    });

    final Map<String, double> newCombinedSales = Map();

    final sortedKeys = combinedSales.keys.toList()
      ..sort((k1, k2) {
        if (selectedDateGrouping == DateGrouping.WEEKLY) {
          return k1.compareTo(k2);
        }

        DateFormat formatter = dailyDateFormat;

        switch (selectedDateGrouping) {
          case DateGrouping.DAILY:
            formatter = dailyDateFormat;
            break;
          case DateGrouping.MONTHLY:
            formatter = monthlyDateFormat;
            break;
          case DateGrouping.YEARLY:
            formatter = yearlyDateFormat;
            break;
          default:
            formatter = dailyDateFormat;
        }

        return Jiffy(k1, formatter.pattern)
            .dateTime
            .compareTo(Jiffy(k2, formatter.pattern).dateTime);
      });

    sortedKeys.forEach((key) {
      newCombinedSales[key] = combinedSales[key];
    });

    print("sorted keys: $sortedKeys");

    add(CombinedSalesEvent(combinedSales: newCombinedSales));
  }

  String _provideFormattedDate({@required DateTime date}) {
    assert(date != null);

    if (_selectedDateGrouping != null) {
      switch (_selectedDateGrouping) {
        case DateGrouping.DAILY:
          return dailyDateFormat.format(date);
        case DateGrouping.WEEKLY:
          return weeklyDateFormat(date);
        case DateGrouping.MONTHLY:
          return monthlyDateFormat.format(date);
        case DateGrouping.YEARLY:
          return yearlyDateFormat.format(date);
        default:
          return dailyDateFormat.format(date);
      }
    } else {
      return dailyDateFormat.format(date);
    }
  }
}

enum DateGrouping { DAILY, WEEKLY, MONTHLY, YEARLY }

part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
}

class ReportsErrorEvent extends ReportsEvent {
  final String errorMessage;

  const ReportsErrorEvent({@required this.errorMessage})
      : assert(errorMessage != null),
        super();

  @override
  List<Object> get props => [this.errorMessage];
}

class UsersRetrievedEvent extends ReportsEvent {
  final List<User> users;

  const UsersRetrievedEvent({@required this.users})
      : assert(users != null),
        super();

  @override
  List<Object> get props => [this.users];
}

class StoresRetrievedEvent extends ReportsEvent {
  final List<Store> stores;

  const StoresRetrievedEvent({@required this.stores})
      : assert(stores != null),
        super();

  @override
  List<Object> get props => [this.stores];
}

class ProductsRetrievedEvent extends ReportsEvent {
  final List<Product> products;

  const ProductsRetrievedEvent({@required this.products})
      : assert(products != null),
        super();

  @override
  List<Object> get props => [this.products];
}

class RidersRetrievedEvent extends ReportsEvent {
  final List<Rider> riders;

  const RidersRetrievedEvent({@required this.riders})
      : assert(riders != null),
        super();

  @override
  List<Object> get props => [this.riders];
}

class VehiclesRetrievedEvent extends ReportsEvent {
  final List<Vehicle> vehicles;

  const VehiclesRetrievedEvent({@required this.vehicles})
      : assert(vehicles != null),
        super();

  @override
  List<Object> get props => [this.vehicles];
}

class OrdersRetrievedEvent extends ReportsEvent {
  final List<Order> orders;

  const OrdersRetrievedEvent({@required this.orders})
      : assert(orders != null),
        super();

  @override
  List<Object> get props => [this.orders];
}

class DeliveriesRetrievedEvent extends ReportsEvent {
  final List<Delivery> deliveries;

  const DeliveriesRetrievedEvent({@required this.deliveries})
      : assert(deliveries != null),
        super();

  @override
  List<Object> get props => [this.deliveries];
}

class AddressesRetrievedEvent extends ReportsEvent {
  final List<Address> addresses;

  const AddressesRetrievedEvent({@required this.addresses})
      : assert(addresses != null),
        super();

  @override
  List<Object> get props => [this.addresses];
}

class OrderDashboardDataEvent extends ReportsEvent {
  final Map<String, double> dailySales;
  final Map<String, int> mostOrderedProduct;
  final Map<String, int> leastOrderedProduct;

  const OrderDashboardDataEvent(
      {@required this.dailySales,
      @required this.mostOrderedProduct,
      @required this.leastOrderedProduct})
      : assert(dailySales != null),
        assert(mostOrderedProduct != null),
        super();

  @override
  List<Object> get props => [];
}

class DateFilterSelectedEvent extends ReportsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const DateFilterSelectedEvent(
      {@required this.startDate, @required this.endDate})
      : assert(startDate != null),
        assert(endDate != null),
        super();

  @override
  List<Object> get props => [this.startDate, this.endDate];
}

class ClearDateFilterEvent extends ReportsEvent {
  @override
  List<Object> get props => [generateId()];
}

class DateGroupingSelectedEvent extends ReportsEvent {
  final DateGrouping grouping;

  const DateGroupingSelectedEvent({@required this.grouping})
      : assert(grouping != null),
        super();

  @override
  List<Object> get props => [this.grouping];
}

class ProvideSalesPerStoreEvent extends ReportsEvent {
  final Map<Store, double> storeSales;

  const ProvideSalesPerStoreEvent({@required this.storeSales})
      : assert(storeSales != null),
        super();

  @override
  List<Object> get props => [this.storeSales];
}

class ProvideStoreJoinGroupingEvent extends ReportsEvent {
  final Map<String, List<Store>> mappedStoreJoinDate;

  const ProvideStoreJoinGroupingEvent({@required this.mappedStoreJoinDate})
      : assert(mappedStoreJoinDate != null),
        super();

  @override
  List<Object> get props => [this.mappedStoreJoinDate];
}

class ProvideDetailedStoresSalesEvent extends ReportsEvent {
  final Map<Store, Map<String, double>> mapDetailedStoreSales;
  final Map<Store, double> mapStoreTotalSales;
  final Map<String, StoreReports> mappedStoreReports;

  const ProvideDetailedStoresSalesEvent(
      {@required this.mapDetailedStoreSales,
      @required this.mapStoreTotalSales,
      @required this.mappedStoreReports})
      : assert(mapDetailedStoreSales != null),
        assert(mapStoreTotalSales != null),
        assert(mappedStoreReports != null),
        super();

  @override
  List<Object> get props => [
        this.mapDetailedStoreSales,
        this.mapStoreTotalSales,
        this.mappedStoreReports
      ];
}

class ProvideRiderJoinGroupingsEvent extends ReportsEvent {
  final Map<String, List<Rider>> mappedRiderJoinGroupings;

  const ProvideRiderJoinGroupingsEvent(
      {@required this.mappedRiderJoinGroupings})
      : assert(mappedRiderJoinGroupings != null),
        super();

  @override
  List<Object> get props => [this.mappedRiderJoinGroupings];
}

class ProvideRiderDetailedSalesEvent extends ReportsEvent {
  final Map<Rider, Map<String, double>> mappedDetailedRiderSales;
  final Map<Rider, double> mappedRiderTotalSales;
  final Map<String, RiderReports> mappedRiderReports;

  const ProvideRiderDetailedSalesEvent(
      {@required this.mappedRiderTotalSales,
      @required this.mappedDetailedRiderSales,
      @required this.mappedRiderReports})
      : assert(mappedRiderTotalSales != null),
        assert(mappedDetailedRiderSales != null),
        assert(mappedRiderReports != null),
        super();

  @override
  List<Object> get props => [
        this.mappedRiderTotalSales,
        this.mappedDetailedRiderSales,
        this.mappedRiderReports
      ];
}

class DeliveriesDashboardDataEvent extends ReportsEvent {
  final Map<String, double> mappedDeliveryTotalSales;

  const DeliveriesDashboardDataEvent({@required this.mappedDeliveryTotalSales})
      : assert(mappedDeliveryTotalSales != null),
        super();

  @override
  List<Object> get props => [this.mappedDeliveryTotalSales];
}

class VehicleGroupingEvent extends ReportsEvent {
  final Map<VehicleType, List<Vehicle>> vehicleGroupings;

  const VehicleGroupingEvent({@required this.vehicleGroupings})
      : assert(vehicleGroupings != null),
        super();

  @override
  List<Object> get props => [this.vehicleGroupings];
}

class RequestVehicleForRiderEvent extends ReportsEvent {
  final Rider rider;
  final List<Vehicle> filteredVehicles;

  const RequestVehicleForRiderEvent(
      {@required this.rider, @required this.filteredVehicles})
      : assert(filteredVehicles != null),
        super();

  @override
  List<Object> get props => [this.rider, this.filteredVehicles];
}

class UserGroupedByGenderEvent extends ReportsEvent {
  final Map<Gender, List<User>> userGroupedGender;

  const UserGroupedByGenderEvent({@required this.userGroupedGender})
      : assert(userGroupedGender != null),
        super();

  @override
  List<Object> get props => [this.userGroupedGender];
}

class UserGroupedByMerchantRiderEvent extends ReportsEvent {
  final List<User> storeOwners;
  final List<User> riderOwners;

  const UserGroupedByMerchantRiderEvent(
      {@required this.storeOwners, @required this.riderOwners})
      : assert(storeOwners != null),
        assert(riderOwners != null),
        super();

  @override
  List<Object> get props => [
        this.storeOwners,
        this.riderOwners,
      ];
}

class UserGroupedByAgeEvent extends ReportsEvent {
  final Map<String, List<User>> userGroupedByAge;

  const UserGroupedByAgeEvent({@required this.userGroupedByAge})
      : assert(userGroupedByAge != null),
        super();

  @override
  List<Object> get props => [this.userGroupedByAge];
}

class CombinedSalesEvent extends ReportsEvent {
  final Map<String, double> combinedSales;

  const CombinedSalesEvent({@required this.combinedSales})
      : assert(combinedSales != null),
        super();

  @override
  List<Object> get props => [this.combinedSales];
}

class TriggerStoreActivation extends ReportsEvent {
  final Store store;
  final String message;

  const TriggerStoreActivation({ @required this.store, this.message}): assert(store != null), super();
  @override
  List<Object> get props => [this.store, this.message];

}

class TriggerRiderActivation extends ReportsEvent {
  final Rider rider;
  final String message;

  const TriggerRiderActivation({ @required this.rider, this.message }): assert(rider != null), super();

  @override
  List<Object> get props => [this.rider, this.message];

}

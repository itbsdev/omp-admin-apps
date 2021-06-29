part of 'reports_bloc.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();
}

class ReportsInitial extends ReportsState {
  @override
  List<Object> get props => [];
}

class ReportsLoadingState extends ReportsState {
  final bool show;

  const ReportsLoadingState({ this.show = false}): super();

  @override
  List<Object> get props => [this.show];

}

class ReportsSuccessState extends ReportsState {
  final dynamic data;
  final String message;

  const ReportsSuccessState({this.data, @required this.message}) : super();

  @override
  List<Object> get props => [this.data, this.message, generateId()];
}

class ReportsErrorState extends ReportsState {
  final String errorMessage;

  const ReportsErrorState({@required this.errorMessage})
      : assert(errorMessage != null),
        super();

  @override
  List<Object> get props => [this.errorMessage];
}

class DateFilterSelectedState extends ReportsState {
  final DateTime startDate;
  final DateTime endDate;

  const DateFilterSelectedState(
      {@required this.startDate, @required this.endDate})
      : assert(startDate != null),
        assert(endDate != null),
        super();

  @override
  List<Object> get props => [this.startDate, this.endDate];
}

class DateGroupingSelectedState extends ReportsState {
  final DateGrouping grouping;

  const DateGroupingSelectedState({@required this.grouping})
      : assert(grouping != null),
        super();

  @override
  List<Object> get props => [this.grouping];
}

class ProvideSalesPerStoreState extends ReportsState {
  final Map<Store, double> storeSales;

  const ProvideSalesPerStoreState({@required this.storeSales})
      : assert(storeSales != null),
        super();

  @override
  List<Object> get props => [this.storeSales];
}

class ProvideStoreJoinGroupingState extends ReportsState {
  final Map<String, List<Store>> mappedStoreJoinDate;

  const ProvideStoreJoinGroupingState({@required this.mappedStoreJoinDate})
      : assert(mappedStoreJoinDate != null),
        super();

  @override
  List<Object> get props => [this.mappedStoreJoinDate];
}

class ProvideDetailedStoresSalesState extends ReportsState {
  final Map<Store, Map<String, double>> mapDetailedStoreSales;
  final Map<Store, double> mapStoreTotalSales;

  const ProvideDetailedStoresSalesState(
      {@required this.mapDetailedStoreSales, @required this.mapStoreTotalSales})
      : assert(mapDetailedStoreSales != null),
        assert(mapStoreTotalSales != null),
        super();

  @override
  List<Object> get props => [
        this.mapDetailedStoreSales,
        this.mapStoreTotalSales,
      ];
}

class ProvideRiderJoinGroupingsState extends ReportsState {
  final Map<String, List<Rider>> mappedRiderJoinGroupings;

  const ProvideRiderJoinGroupingsState(
      {@required this.mappedRiderJoinGroupings})
      : assert(mappedRiderJoinGroupings != null),
        super();

  @override
  List<Object> get props => [this.mappedRiderJoinGroupings];
}

class ProvideRiderDetailedSalesState extends ReportsState {
  final Map<Rider, Map<String, double>> mappedDetailedRiderSales;
  final Map<Rider, double> mappedRiderTotalSales;

  const ProvideRiderDetailedSalesState(
      {@required this.mappedRiderTotalSales,
        @required this.mappedDetailedRiderSales})
      : assert(mappedRiderTotalSales != null),
        assert(mappedDetailedRiderSales != null),
        super();

  @override
  List<Object> get props =>
      [this.mappedRiderTotalSales, this.mappedDetailedRiderSales];
}

class DeliveriesDashboardDataState extends ReportsState {
  final Map<String, double> mappedDeliveryTotalSales;

  const DeliveriesDashboardDataState({@required this.mappedDeliveryTotalSales})
      : assert(mappedDeliveryTotalSales != null),
        super();

  @override
  List<Object> get props => [this.mappedDeliveryTotalSales];
}

class VehicleGroupingState extends ReportsState {
  final Map<VehicleType, List<Vehicle>> vehicleGroupings;

  const VehicleGroupingState({ @required this.vehicleGroupings }): assert(vehicleGroupings != null), super();

  @override
  List<Object> get props => [this.vehicleGroupings];
}

class RequestVehicleForRiderState extends ReportsState {
  final Rider rider;
  final List<Vehicle> filteredVehicles;

  const RequestVehicleForRiderState(
      {@required this.rider, @required this.filteredVehicles})
      : assert(filteredVehicles != null),
        super();

  @override
  List<Object> get props => [this.rider, this.filteredVehicles];
}

class UserGroupedByGenderState extends ReportsState {
  final Map<Gender, List<User>> userGroupedGender;

  const UserGroupedByGenderState({@required this.userGroupedGender})
      : assert(userGroupedGender != null),
        super();

  @override
  List<Object> get props => [this.userGroupedGender];
}

class UserGroupedByMerchantRiderState extends ReportsState {
  final List<User> storeOwners;
  final List<User> riderOwners;

  const UserGroupedByMerchantRiderState(
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

class UserGroupedByAgeState extends ReportsState {
  final Map<String, List<User>> userGroupedByAge;

  const UserGroupedByAgeState({ @required this.userGroupedByAge }): assert(userGroupedByAge != null), super();

  @override
  List<Object> get props => [this.userGroupedByAge];
}

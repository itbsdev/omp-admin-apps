part of 'delivery_bloc.dart';

abstract class DeliveryState extends Equatable {
  const DeliveryState();
}

class DeliveryInitial extends DeliveryState {
  @override
  List<Object> get props => [];
}

class DeliveriesRetrievedState extends DeliveryState {
  final List<DeliveryRider> deliveries;

  const DeliveriesRetrievedState({@required this.deliveries})
      : assert(deliveries != null),
        super();

  @override
  List<Object> get props => [this.deliveries];
}

class DeliverySuccessState extends DeliveryState {
  final dynamic data;
  final String message;

  const DeliverySuccessState({this.data, this.message}) : super();

  @override
  List<Object> get props => [this.data, this.message];
}

class DeliveryErrorState extends DeliveryState {
  final String err;

  const DeliveryErrorState({@required this.err})
      : assert(err != null),
        super();

  @override
  List<Object> get props => [this.err, generateId()];
}

class DeliveryLoadingState extends DeliveryState {
  final bool show;

  const DeliveryLoadingState({this.show = false})
      : assert(show != null),
        super();

  @override
  List<Object> get props => [this.show];
}

class RequestDeliveryState extends DeliveryState {
  final Order order;

  const RequestDeliveryState({@required this.order})
      : assert(order != null),
        super();

  @override
  List<Object> get props => [this.order];
}

class RequestDeliveryProgressState extends DeliveryState {
  final String formattedProgress;

  const RequestDeliveryProgressState({@required this.formattedProgress})
      : assert(formattedProgress != null),
        super();

  @override
  List<Object> get props => [this.formattedProgress];
}

class RequestDeliverySuccessState extends DeliverySuccessState {
  const RequestDeliverySuccessState({dynamic data, String message})
      : super(data: data, message: message);
}

class RequestDeliveryErrorState extends DeliveryErrorState {
  const RequestDeliveryErrorState({@required String err}) : super(err: err);
}

class VehicleTypeSelectedState extends DeliveryState {
  final VehicleType vehicleType;

  const VehicleTypeSelectedState({@required this.vehicleType})
      : assert(vehicleType != null),
        super();

  @override
  List<Object> get props => [
        this.vehicleType,
      ];
}

class VehicleCurrentLocationState extends DeliveryState {
  final double latitude;
  final double longitude;

  const VehicleCurrentLocationState(
      {@required this.latitude, @required this.longitude})
      : assert(latitude != null),
        assert(longitude != null),
        super();

  @override
  List<Object> get props => [this.latitude, this.longitude];
}

class DeliveryRetrievedState extends DeliveryState {
  final DeliveryRider deliveryRider;

  const DeliveryRetrievedState({@required this.deliveryRider})
      : assert(deliveryRider != null),
        super();

  @override
  List<Object> get props => [this.deliveryRider];
}

class NavigateToCurrentDeliveryScreenState extends DeliveryState {
  @override
  List<Object> get props => [generateId()];
}

class CallRiderState extends DeliveryState {
  final User rider;

  const CallRiderState({@required this.rider})
      : assert(rider != null),
        super();

  // generate random string to make each event call unique
  @override
  List<Object> get props => [this.rider, generateId()];
}

class SmsRiderState extends DeliveryState {
  final User rider;

  const SmsRiderState({@required this.rider})
      : assert(rider != null),
        super();

  // generate random string to make each event call unique
  @override
  List<Object> get props => [this.rider, generateId()];
}

class ShowLocationToMapState extends DeliveryState {
  final double latitude;
  final double longitude;

  const ShowLocationToMapState(
      {@required this.latitude, @required this.longitude})
      : assert(latitude != null),
        assert(longitude != null),
        super();

  @override
  List<Object> get props => [this.latitude, this.longitude];
}

part of 'delivery_bloc.dart';

abstract class DeliveryEvent extends Equatable {
  const DeliveryEvent();
}

class DeliveriesRetrievedEvent extends DeliveryEvent {
  final List<DeliveryRider> deliveries;

  const DeliveriesRetrievedEvent({@required this.deliveries})
      : assert(deliveries != null),
        super();

  @override
  List<Object> get props => [this.deliveries];
}

class DeliveryRetrievedEvent extends DeliveryEvent {
  final DeliveryRider deliveryRider;

  const DeliveryRetrievedEvent({@required this.deliveryRider})
      : assert(deliveryRider != null),
        super();

  @override
  List<Object> get props => [
    this.deliveryRider
  ];
}

class DeliverySuccessEvent extends DeliveryEvent {
  final dynamic data;
  final String message;

  const DeliverySuccessEvent({this.data, this.message}) : super();

  @override
  List<Object> get props => [this.data, this.message];
}

class DeliveryErrorEvent extends DeliveryEvent {
  final String err;

  const DeliveryErrorEvent({@required this.err})
      : assert(err != null),
        super();

  @override
  List<Object> get props => [this.err];
}

class RequestDeliveryEvent extends DeliveryEvent {
  final Order order;

  const RequestDeliveryEvent({@required this.order})
      : assert(order != null),
        super();

  @override
  List<Object> get props => [this.order];
}

class RequestDeliveryProgressEvent extends DeliveryEvent {
  final int progress;

  const RequestDeliveryProgressEvent({@required this.progress})
      : assert(progress != null),
        super();

  @override
  List<Object> get props => [this.progress];
}

class RequestDeliverySuccessEvent extends DeliverySuccessEvent {
  const RequestDeliverySuccessEvent({@required dynamic data, String message})
      : super(data: data, message: message);
}

class RequestDeliveryErrorEvent extends DeliveryErrorEvent {
  const RequestDeliveryErrorEvent({@required String err}) : super(err: err);
}

class VehicleTypeSelectedEvent extends DeliveryEvent {
  final VehicleType vehicleType;

  const VehicleTypeSelectedEvent({@required this.vehicleType})
      : assert(vehicleType != null),
        super();

  @override
  List<Object> get props => [
        this.vehicleType,
      ];
}

class VehicleCurrentLocationEvent extends DeliveryEvent {
  final double latitude;
  final double longitude;

  const VehicleCurrentLocationEvent(
      {@required this.latitude, @required this.longitude})
      : assert(latitude != null),
        assert(longitude != null),
        super();

  @override
  List<Object> get props => [this.latitude, this.longitude];
}

class CallRiderEvent extends DeliveryEvent {
  final User rider;

  const CallRiderEvent({@required this.rider})
      : assert(rider != null),
        super();

  // generate random string to make each event call unique
  @override
  List<Object> get props => [this.rider, generateId()];
}

class SmsRiderEvent extends DeliveryEvent {
  final User rider;

  const SmsRiderEvent({@required this.rider})
      : assert(rider != null),
        super();

  // generate random string to make each event call unique
  @override
  List<Object> get props => [this.rider, generateId()];
}

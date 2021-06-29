part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class OrderUpdateEvent extends OrderEvent {
  final int position;
  final Order order;

  const OrderUpdateEvent({@required this.position, @required this.order})
      : assert(position != null),
        assert(order != null),
        super();

  @override
  List<Object> get props => [this.order];
}

class OrderDeleteEvent extends OrderEvent {
  final String orderId;

  const OrderDeleteEvent({@required this.orderId})
      : assert(orderId != null),
        super();

  @override
  List<Object> get props => [this.orderId];
}

class OrderRetrieveEvent extends OrderEvent {
  final String orderId;

  const OrderRetrieveEvent({@required this.orderId}) : super();

  @override
  List<Object> get props => [this.orderId];
}

class OrdersRetrieveEvent extends OrderEvent {
  final List<OrderView> orders;

  const OrdersRetrieveEvent({@required this.orders})
      : assert(orders != null),
        super();

  @override
  List<Object> get props => [this.orders];
}

class OrderProductAndUserAndAddressRetrievedEvent extends OrderEvent {
  final Product product;
  final User customer;
  final String shippingAddress;

  const OrderProductAndUserAndAddressRetrievedEvent({@required this.product,
    @required this.customer,
    @required this.shippingAddress})
      : assert(product != null),
        assert(customer != null),
        assert(shippingAddress != null),
        super();

  @override
  List<Object> get props => [this.product, this.customer, this.shippingAddress];
}

class MessageCustomerOrderEvent extends OrderEvent {
  @override
  List<Object> get props => [];
}

class DashboardDataEvent extends OrderEvent {
  final Map<String, double> dailySales;
  final Map<String, int> mostOrderedProduct;
  final Map<String, int> leastOrderedProduct;

  const DashboardDataEvent(
      { @required this.dailySales, @required this.mostOrderedProduct, @required this.leastOrderedProduct })
      : assert(dailySales != null),
        assert(mostOrderedProduct != null),
        super();

  @override
  List<Object> get props => [];
}

class OrderFilterEvent extends OrderEvent {
  final OrderStatus status;

  const OrderFilterEvent({ @required this.status }): assert(status != null), super();

  @override
  List<Object> get props => [];
}

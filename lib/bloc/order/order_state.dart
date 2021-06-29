part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();
}

class OrderInitialState extends OrderState {
  @override
  List<Object> get props => [];
}

class OrderLoadingState extends OrderState {
  final bool show;

  const OrderLoadingState({ this.show = true}): super();

  @override
  List<Object> get props => [this.show];
}

class OrdersRetrievedState extends OrderState {
  final List<OrderView> orders;

  const OrdersRetrievedState({this.orders})
      : assert(orders != null),
        super();

  @override
  List<Object> get props => [this.orders];
}

class OrderUpdatedState extends OrderState {
  final Order order;

  const OrderUpdatedState({this.order})
      : assert(order != null),
        super();

  @override
  List<Object> get props => [this.order];
}

class OrderHistoriesState extends OrderState {
  final List<Order> histories;

  const OrderHistoriesState({this.histories})
      : assert(histories != null),
        super();

  @override
  List<Object> get props => [this.histories];
}

class OrderSuccessState extends OrderState {
  final String message;

  const OrderSuccessState({this.message}) : super();

  @override
  List<Object> get props => [];
}

class OrderErrorState extends OrderState {
  final String error;

  const OrderErrorState({this.error}) : super();

  @override
  List<Object> get props => [];
}

class OrderProductAndUserAndAddressRetrievedState extends OrderState {
  final Product product;
  final User customer;
  final String shippingAddress;

  const OrderProductAndUserAndAddressRetrievedState(
      {@required this.product, @required this.customer, this.shippingAddress})
      : assert(product != null),
        assert(customer != null),
        assert(shippingAddress != null),
        super();

  @override
  List<Object> get props => [this.product, this.customer, this.shippingAddress];
}

class MessageCustomerOrderState extends OrderState {
  final ChatRooms chatRoom;

  const MessageCustomerOrderState({ @required this.chatRoom }): assert(chatRoom != null), super();

  @override
  List<Object> get props => [this.chatRoom];
}

class DashboardDataState extends OrderState {
  final Map<String, double> dailySales;
  final Map<String, int> mostOrderedProduct;
  final Map<String, int> leastOrderedProduct;

  const DashboardDataState(
      { @required this.dailySales, @required this.mostOrderedProduct, @required this.leastOrderedProduct })
      : assert(dailySales != null),
        assert(mostOrderedProduct != null),
        super();

  @override
  List<Object> get props => [];
}

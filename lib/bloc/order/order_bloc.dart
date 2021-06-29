import 'dart:async';

import 'package:admin_app/config/extensions.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/chat_rooms.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/model/order_view.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/model/user.dart';
import 'package:admin_app/repository/address/address_repository.dart';
import 'package:admin_app/repository/chat_room/chat_room_repository.dart';
import 'package:admin_app/repository/order/order_repository.dart';
import 'package:admin_app/repository/product/product_repository.dart';
import 'package:admin_app/repository/user/user_repository.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ProductRepository _productRepository;
  final OrderRepository _orderRepository;
  final UserRepository _userRepository;
  final AddressRepository _addressRepository;
  final ChatRoomRepository _chatRoomRepository;

  OrderBloc(this._orderRepository, this._productRepository,
      this._userRepository, this._addressRepository, this._chatRoomRepository)
      : super(OrderInitialState()) {
    _totalSalesToDate = 0.0;
    this._getOrders();
//    this._createTempOrders();
  }

  Map<int, Order> _lastOrderSaved = null;

  Product _selectedProduct;

  Product get selectedProduct => _selectedProduct;

  User _selectedCustomer;

  User get customer => _selectedCustomer;

  Order _selectedOrder;

  Order get selectedOrder => _selectedOrder;

  List<OrderView> _orders;

  List<OrderView> _originalOrders;

  String _shippingAddress;

  String get shippingAddress => _shippingAddress ?? "";

  List<OrderView> get orders => _orders == null ? [] : _orders;

  List<OrderView> _histories;

  List<OrderView> get histories => _histories == null ? [] : _histories;

  Map<String, double> _dailySales;

  Map<String, double> get dailySales => _dailySales == null ? Map() : _dailySales;

  Map<String, int> _mostOrderedProduct;

  Map<String, int> get mostOrderedProduct => _mostOrderedProduct == null ? Map() : _mostOrderedProduct;

  Map<String, int> _leastOrderedProduct;

  Map<String, int> get leastOrderedProduct => _leastOrderedProduct == null ? Map() : _leastOrderedProduct;

  double _totalSalesToDate = 0.0;

  double get totalSalesToDate => _totalSalesToDate;

  void clear() {
    _selectedProduct = null;
    _selectedCustomer = null;
    _shippingAddress = null;
  }

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    yield OrderInitialState();

    try {
      if (event is OrdersRetrieveEvent) {
        if (_orders == null) _orders = List();
        if (_originalOrders == null) _originalOrders = List();
        if (_histories == null) _histories = List();

        _orders.clear();
        _originalOrders.clear();
        _orders.addAll(event.orders.where((element) =>
            orderTransactionList.indexOf(element.order.status) != -1));
        _originalOrders.addAll(_orders);
        _orders.sort((o1, o2) => o1.order.status.index.compareTo(o2.order.status.index));
        _originalOrders.sort((o1, o2) => o1.order.status.index.compareTo(o2.order.status.index));
        _histories.clear();
        _histories.addAll(event.orders.where(
            (element) => orderHistoryList.indexOf(element.order.status) != -1));

        if (_lastOrderSaved != null) {
          int position = _lastOrderSaved.keys.toList()[0];

          if (position != SAVED_NO_POSITION) {
            final tmpOrder = _lastOrderSaved.values.toList()[0];
            final tmpProduct =
                await _productRepository.load(id: tmpOrder.productId);
            final tmpCustomer =
                await _userRepository.load(id: tmpOrder.customerId);
            _orders[position] = OrderView(
                order: tmpOrder, product: tmpProduct, customer: tmpCustomer);
            _lastOrderSaved = null;
          }
        }

        yield OrdersRetrievedState(orders: _orders);
      } else if (event is OrderUpdateEvent) {
        yield OrderLoadingState();

        if (event.order.status == OrderStatus.APPROVED) {
          if (_selectedProduct != null) {
            final productQuantity = _selectedProduct.quantity;
            final orderQuantity = event.order.quantity;
            if ((productQuantity - orderQuantity) < 0) {
              yield OrderLoadingState(show: false);
              yield OrderErrorState(
                  error:
                      "Order quantity is too many for the available remaining quantity");
              return;
            }

            _selectedProduct.quantity = productQuantity - orderQuantity.toInt();
            await _productRepository.update(datum: _selectedProduct);
          }
        }

        await _orderRepository.update(datum: event.order);
        final position = event.position;
        if (position != null) {
          final previousOrderView = _orders[position];
          previousOrderView.order = event.order;
          _orders[position] = previousOrderView;
        }

        _lastOrderSaved = {position: event.order};
        _selectedOrder = event.order;
        yield OrderLoadingState(show: false);
        yield OrderSuccessState();
      } else if (event is OrderProductAndUserAndAddressRetrievedEvent) {
        _selectedProduct = event.product;
        _selectedCustomer = event.customer;
        _shippingAddress = event.shippingAddress;

        yield OrderProductAndUserAndAddressRetrievedState(
            product: event.product,
            customer: event.customer,
            shippingAddress: event.shippingAddress);
      } else if (event is MessageCustomerOrderEvent) {
        yield OrderLoadingState();

        if (_selectedOrder == null) {
          yield OrderLoadingState(show: false);
          yield OrderErrorState(
              error: "Cannot start chat. Order item not defined");
        } else {
          final storeId = _selectedOrder.storeId;
          final customerId = _selectedOrder.customerId;
          var chatRoom = await _chatRoomRepository.loadByCustomer(
              storeId: storeId, customerId: customerId);

          if (chatRoom == null) {
            final tmpChatRoom = ChatRooms(
                storeId: storeId,
                customerId: customerId,
                name:
                    "Messages with ${_selectedCustomer?.name ?? "customer $customerId"}");

            final chatRoomId =
                await _chatRoomRepository.insert(datum: tmpChatRoom);
            final tmpChatRoomJson = tmpChatRoom.toJson();
            tmpChatRoomJson["id"] = chatRoomId;
            chatRoom = ChatRooms.fromJson(tmpChatRoomJson);
          }

          yield OrderLoadingState(show: false);
          yield OrderSuccessState();
          yield (MessageCustomerOrderState(chatRoom: chatRoom));
        }
      } else if (event is DashboardDataEvent) {
        _dailySales = event.dailySales;
        _mostOrderedProduct = event.mostOrderedProduct;
        _leastOrderedProduct = event.leastOrderedProduct;

        yield DashboardDataState(
            dailySales: event.dailySales,
            mostOrderedProduct: event.mostOrderedProduct,
            leastOrderedProduct: event.leastOrderedProduct);
      }
    } catch (err) {
      print("order_bloc: error: $err");

      if (event is MessageCustomerOrderEvent) {
        if (_selectedOrder == null) {
          yield OrderLoadingState(show: false);
          yield OrderErrorState(
              error: "Cannot start chat. Order item not defined");
        } else {
          final storeId = _selectedOrder.storeId;
          final customerId = _selectedOrder.customerId;
          final tmpChatRoom = ChatRooms(
              storeId: storeId,
              customerId: customerId,
              name:
                  "Messages with ${_selectedCustomer?.name ?? "customer $customerId"}");

          final chatRoomId =
              await _chatRoomRepository.insert(datum: tmpChatRoom);
          final tmpChatRoomJson = tmpChatRoom.toJson();
          tmpChatRoomJson["id"] = chatRoomId;
          final chatRoom = ChatRooms.fromJson(tmpChatRoomJson);

          yield OrderLoadingState(show: false);
          yield (MessageCustomerOrderState(chatRoom: chatRoom));
        }
      } else {
        yield OrderLoadingState(show: false);
        yield OrderErrorState(error: err.toString());
      }
    }
  }

  void _getOrders() async {
    _orderRepository.loadAll().listen((event) async {
      _parseOrdersForDashboard(event);

      final futureOrderView = event.map((e) async {
        final product = await _productRepository.load(id: e.productId);
        final customer = await _userRepository.load(id: e.customerId);
        return OrderView(order: e, product: product, customer: customer);
      });

      final tempOrderView = await Future.wait(futureOrderView);

      add(OrdersRetrieveEvent(orders: tempOrderView));
    });
  }

  void _createTempOrders() async {
    final tempOrders = [];

    for (var i = 0; i < 10; i++) {
      final tempOrder = Order(
          status: OrderStatus.SUBMITTED,
          customerId: "customer-$i",
          productId: "65XwNgXKf8AQaQSAGhpk",
          storeId: "9AcsIDpjnlqGfFRMQyoc",
          quantity: 1,
          price: 100,
          receiverName: "receiver for customer $i",
          receiverAddress: "receiver address for customer $i",
          receiverMobileNumber: "receiver mobile number for customer $i");

      tempOrders.add(tempOrder);
    }

    await Future.forEach(
        tempOrders, (element) => _orderRepository.insert(datum: element));
  }

  void updateOrder(
      {@required int position,
      @required Order order,
      @required OrderStatus newOrderStatus}) {
    if (order == null) return;

    final newOrderMap = order.toJson();
    newOrderMap["status"] = orderStatusEnumMap[newOrderStatus];
    add(OrderUpdateEvent(
        position: position, order: Order.fromJson(newOrderMap)));
  }

  void selectOrder({Order order}) async {
    assert(order != null);
    _selectedOrder = order;

    final product = await _productRepository.load(id: order.productId);
    final user = await _userRepository.load(id: order.customerId);
    final address = order.shipToAddressId == null
        ? null
        : await _addressRepository.load(id: order.shipToAddressId);

    add(OrderProductAndUserAndAddressRetrievedEvent(
        product: product, customer: user, shippingAddress: address.toString()));
  }

  void sendMessageToCustomer() {
    add(MessageCustomerOrderEvent());
  }

  void _parseOrdersForDashboard(List<Order> orders) async {
    print("orders: $orders");
    print("parse orders called");

    _totalSalesToDate  = 0.0;
    orders.forEach((element) {
      _totalSalesToDate += (element.price * element.quantity);
    });

    /// generate sales day per day
    final dailyGroupedOrders = groupBy(
        orders,
        (order) => dailyDateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(order.updatedAt.toInt())));
    final Map<String, double> dailyGroupedOrderSales = Map();

    dailyGroupedOrders.forEach((key, orders) {
      double totalSales = 0.0;

      orders.forEach((order) => totalSales += (order.price * order.quantity));

      dailyGroupedOrderSales[key] = totalSales;
    });

    print("daily sales: $dailyGroupedOrderSales}");

    final groupedByProductId = groupBy(orders, (order) => order.productId);
    final Map<String, int> sumQuantityPerProduct = Map();

    groupedByProductId.forEach((key, orders) {
      int totalQuantity = 0;

      orders.forEach((order) => totalQuantity += order.quantity.toInt());

      sumQuantityPerProduct[key] = totalQuantity;
    });

    /// can also be the least if there is only one product that's
    /// being ordered for the moment
    final Map<String, int> leastOrderedProductsNamed = Map();
    final Map<String, int> mostOrderedProductsNamed = Map();

    if (sumQuantityPerProduct.isNotEmpty && sumQuantityPerProduct.length > 1) {
      final leastOrderedProductKeys = sumQuantityPerProduct.keys.toList()
        ..sort((o1, o2) =>
            sumQuantityPerProduct[o1].compareTo(sumQuantityPerProduct[o2]));
      final leastOrderedProducts = Map.fromIterable(leastOrderedProductKeys,
          key: (k) => k, value: (k) => sumQuantityPerProduct[k]);

      for (var entry in leastOrderedProducts.entries) {
        final product = await _productRepository.load(id: entry.key);
        leastOrderedProductsNamed[product.name] = entry.value;
      }

      final mostOrderedProductKeys = leastOrderedProductKeys.reversed;
      final mostOrderedProducts = Map.fromIterable(mostOrderedProductKeys,
          key: (k) => k, value: (k) => sumQuantityPerProduct[k]);

      for (var entry in mostOrderedProducts.entries) {
        final product = await _productRepository.load(id: entry.key);
        mostOrderedProductsNamed[product.name] = entry.value;
      }

      print("least ordered products: $leastOrderedProductsNamed}");

      add(DashboardDataEvent(dailySales: dailyGroupedOrderSales, mostOrderedProduct: mostOrderedProductsNamed, leastOrderedProduct: leastOrderedProductsNamed));
    } else {
      for (var entry in sumQuantityPerProduct.entries) {
        final product = await _productRepository.load(id: entry.key);
        mostOrderedProductsNamed[product.name] = entry.value;
      }

      add(DashboardDataEvent(dailySales: dailyGroupedOrderSales, mostOrderedProduct: mostOrderedProductsNamed, leastOrderedProduct: null));
    }

    print("most ordered products: $sumQuantityPerProduct");
    print("most ordered products: $mostOrderedProductsNamed");
  }
}

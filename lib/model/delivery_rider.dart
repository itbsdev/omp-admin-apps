import 'package:flutter/material.dart';
import 'package:admin_app/model/delivery.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/model/user.dart';
import 'package:admin_app/model/vehicle.dart';

class DeliveryRider {
  final User rider;
  final Vehicle vehicle;
  final Delivery delivery;
  final Order order;
  final Product product;
  final User customer;

  const DeliveryRider(
      {@required this.rider,
      @required this.vehicle,
      @required this.delivery,
      @required this.order,
      @required this.product,
      @required this.customer })
      : assert(delivery != null);
}

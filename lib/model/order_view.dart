import 'package:flutter/material.dart';
import 'package:admin_app/model/delivery.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/model/user.dart';

class OrderView {
    Order order;
    final Product product;
    final User customer;
    Delivery delivery;

    OrderView({
        @required this.order,
        @required this.product,
        @required this.customer,
        this.delivery
    }): assert(order != null), assert(product != null), assert(customer != null);
}

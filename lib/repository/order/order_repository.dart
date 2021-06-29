import 'package:flutter/material.dart';
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/order.dart';

abstract class OrderRepository with BaseRepository<Order> {
  Future<List<Order>> loadByProduct({ @required String productId });

  Stream<List<Order>> loadAll();
}

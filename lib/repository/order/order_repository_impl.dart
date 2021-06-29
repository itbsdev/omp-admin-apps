import 'package:flutter/material.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/repository/order/order_repository.dart';
import 'package:admin_app/service/orders_firestore_service.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrdersFirestoreService ordersFirestoreService;

  OrderRepositoryImpl({@required this.ordersFirestoreService});

  @override
  Future<String> delete({String id}) {
    return ordersFirestoreService.delete(orderId: id);
  }

  @override
  Future<String> insert({Order datum}) {
    return ordersFirestoreService.store(order: datum);
  }

  @override
  Future<Order> load({String id}) {
    return ordersFirestoreService.load(orderId: id);
  }

  @override
  Stream<List<Order>> loadByCompany({String companyId}) {
    return ordersFirestoreService.loadByCompany(companyId: companyId);
  }

  @override
  Future<String> update({Order datum}) {
    return ordersFirestoreService.update(order: datum);
  }

  @override
  Future<List<Order>> loadByProduct({String productId}) {
    return ordersFirestoreService.loadByProduct(productId: productId);
  }

  @override
  Stream<List<Order>> loadAll() {
    return ordersFirestoreService.loadAll();
  }
}

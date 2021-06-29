import 'package:admin_app/model/store.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StoreReports extends Equatable {
  final Store store;

  /// totalSales are based on amount incurred
  final double totalSales;

  /// total cancellations are based on quantity
  final int totalCancellations;

  /// final total confirmed orders
  final int totalConfirmedOrders;

  /// final total delivered orders
  final int totalDeliveredOrders;

  /// based on total sales per day, per week, per month and per year
  final Map<String, double> detailedSales;

  /// based on total cancellations per day, per week, per month and per year
  final Map<String, int> detailedCancellations;

  /// based on total confirmed orders per day, per week, per month and per year
  final Map<String, int> detailedConfirmedOrders;

  /// based on total delivered orders per day, per week, per month and per year
  final Map<String, int> detailedDeliveredOrders;

  StoreReports({
    @required this.store,
    @required this.totalSales,
    @required this.totalCancellations,
    @required this.totalConfirmedOrders,
    @required this.totalDeliveredOrders,
    @required this.detailedSales,
    @required this.detailedCancellations,
    @required this.detailedConfirmedOrders,
    @required this.detailedDeliveredOrders,
  })  : assert(store != null),
        assert(totalSales != null),
        assert(totalCancellations != null),
        assert(totalConfirmedOrders != null),
        assert(totalDeliveredOrders != null),
        assert(detailedSales != null),
        assert(detailedCancellations != null),
        assert(detailedConfirmedOrders != null),
        assert(detailedDeliveredOrders != null);

  @override
  List<Object> get props => [
        this.store,
        this.totalSales,
        this.totalCancellations,
        this.totalConfirmedOrders,
        this.totalDeliveredOrders,
        this.detailedSales,
        this.detailedCancellations,
        this.detailedConfirmedOrders,
        this.detailedDeliveredOrders,
      ];
}

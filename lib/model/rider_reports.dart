import 'package:admin_app/model/rider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RiderReports extends Equatable {
  final Rider rider;

  /// totalSales are based on amount incurred
  final double totalSales;

  /// total cancellations are based on quantity
  final int totalCancellations;

  /// final total delivered orders
  final int totalDeliveredOrders;

  /// based on total sales per day, per week, per month and per year
  final Map<String, double> detailedSales;

  /// based on total cancellations per day, per week, per month and per year
  final Map<String, int> detailedCancellations;

  /// based on total delivered orders per day, per week, per month and per year
  final Map<String, int> detailedDeliveredOrders;

  RiderReports({
    @required this.rider,
    @required this.totalSales,
    @required this.totalCancellations,
    @required this.totalDeliveredOrders,
    @required this.detailedSales,
    @required this.detailedCancellations,
    @required this.detailedDeliveredOrders,
  })  : assert(rider != null),
        assert(totalSales != null),
        assert(totalCancellations != null),
        assert(totalDeliveredOrders != null),
        assert(detailedSales != null),
        assert(detailedCancellations != null),
        assert(detailedDeliveredOrders != null);

  @override
  List<Object> get props => [
        this.rider,
        this.totalSales,
        this.totalCancellations,
        this.totalDeliveredOrders,
        this.detailedSales,
        this.detailedCancellations,
        this.detailedDeliveredOrders,
      ];
}

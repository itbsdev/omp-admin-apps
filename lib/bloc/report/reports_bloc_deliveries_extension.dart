part of "reports_bloc.dart";

extension DeliveriesReportsBloc on ReportsBloc {
  void _parseDeliveriesForDashboard({@required List<Delivery> deliveries}) {
    assert(deliveries != null);

    final Map<String, double> mappedTotalSalesByDate = Map();

    List<Delivery> filteredDeliveries = deliveries;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      filteredDeliveries = deliveries
          .where((element) =>
      element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();
    }

    final groupings = filteredDeliveries.groupListsBy((delivery) =>
        _provideFormattedDate(
            date: DateTime.fromMillisecondsSinceEpoch(delivery.updatedAt)));

    groupings.forEach((dateStr, inDeliveries) {
      final totalSale = inDeliveries.fold(0.0,
          (previousValue, delivery) => previousValue + delivery.totalPayment);

      mappedTotalSalesByDate[dateStr] = totalSale;
    });

    add(DeliveriesDashboardDataEvent(mappedDeliveryTotalSales: mappedTotalSalesByDate));
  }
}

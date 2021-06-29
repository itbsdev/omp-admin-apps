part of 'reports_bloc.dart';

extension OrderReportsBloc on ReportsBloc {
  void _parseOrdersForDashboard(List<Order> orders) async {
    print("orders: $orders");
    print("parse orders called");

    _totalSalesToDate = 0.0;
    orders.forEach((element) {
      _totalSalesToDate += (element.price * element.quantity);
    });

    List<Order> filteredOrders = orders;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      filteredOrders = orders.where((element) =>
          element.updatedAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.updatedAt <= _selectedEndDate.millisecondsSinceEpoch)
      .toList();
    }

    /// generate sales day per day
    final dailyGroupedOrders = groupBy(
        filteredOrders,
        (order) => _provideFormattedDate(
            date:
                DateTime.fromMillisecondsSinceEpoch(order.updatedAt.toInt())));
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
        final product = await productRepository.load(id: entry.key);
        leastOrderedProductsNamed[product.name] = entry.value;
      }

      final mostOrderedProductKeys = leastOrderedProductKeys.reversed;
      final mostOrderedProducts = Map.fromIterable(mostOrderedProductKeys,
          key: (k) => k, value: (k) => sumQuantityPerProduct[k]);

      for (var entry in mostOrderedProducts.entries) {
        final product = await productRepository.load(id: entry.key);
        mostOrderedProductsNamed[product.name] = entry.value;
      }

      print("least ordered products: $leastOrderedProductsNamed}");

      add(OrderDashboardDataEvent(
          dailySales: dailyGroupedOrderSales,
          mostOrderedProduct: mostOrderedProductsNamed,
          leastOrderedProduct: leastOrderedProductsNamed));
    } else {
      for (var entry in sumQuantityPerProduct.entries) {
        final product = await productRepository.load(id: entry.key);
        mostOrderedProductsNamed[product.name] = entry.value;
      }

      add(OrderDashboardDataEvent(
          dailySales: dailyGroupedOrderSales,
          mostOrderedProduct: mostOrderedProductsNamed,
          leastOrderedProduct: null));
    }

    print("most ordered products: $sumQuantityPerProduct");
    print("most ordered products: $mostOrderedProductsNamed");
  }
}

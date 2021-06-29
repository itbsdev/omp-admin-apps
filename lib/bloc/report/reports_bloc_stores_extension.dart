part of 'reports_bloc.dart';

extension StoresReportsBloc on ReportsBloc {
  void _provideStoreJoinGroupings({@required List<Store> stores}) {
    assert(stores != null);
    _selectedDateGrouping = DateGrouping.DAILY;
    Map<String, List<Store>> mappedStore;
    List<Store> filteredStores = stores;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      filteredStores = stores.where((element) =>
          element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
      .toList();
    }

    if (_selectedDateGrouping != null) {
      switch (_selectedDateGrouping) {
        case DateGrouping.DAILY:
          mappedStore = filteredStores.groupListsBy((element) => dailyDateFormat
              .format(DateTime.fromMillisecondsSinceEpoch(element.createdAt)));
          break;
        case DateGrouping.WEEKLY:
          mappedStore = filteredStores.groupListsBy((element) => weeklyDateFormat(
              DateTime.fromMillisecondsSinceEpoch(element.createdAt)));
          break;
        case DateGrouping.MONTHLY:
          mappedStore = filteredStores.groupListsBy((element) => monthlyDateFormat
              .format(DateTime.fromMillisecondsSinceEpoch(element.createdAt)));
          break;
        case DateGrouping.YEARLY:
          mappedStore = filteredStores.groupListsBy((element) => yearlyDateFormat
              .format(DateTime.fromMillisecondsSinceEpoch(element.createdAt)));
          break;
        default:
          mappedStore = filteredStores.groupListsBy((element) => dailyDateFormat
              .format(DateTime.fromMillisecondsSinceEpoch(element.createdAt)));
      }
    } else {
      mappedStore = filteredStores.groupListsBy((element) => dailyDateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(element.createdAt)));
    }

    // mappedStore.forEach((key, value) {
    //   print("date in string is: $key");
    //   print("stores: ${value.map((e) => e.name).toList().join(", ")}");
    // });

    add(ProvideStoreJoinGroupingEvent(mappedStoreJoinDate: mappedStore));
  }

  void _provideDetailedStoresSales(
      {@required List<Store> stores, @required List<Order> orders}) {
    assert(orders != null);
    assert(stores != null);

    Map<Store, Map<String, double>> mappedDetailedStoreSales = Map();
    Map<Store, double> mappedStoreTotalSales = Map();
    Map<String, StoreReports> mappedStoreReports = Map();
    List<Store> filteredStores = stores;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      filteredStores = stores.where((element) =>
      element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();
    }

    List<Order> filteredOrders = orders;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      filteredOrders = orders.where((element) =>
      element.updatedAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.updatedAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();
    }

    final groupedOrderByStore =
    filteredOrders.groupListsBy((element) => element.storeId);

    groupedOrderByStore.forEach((storeId, storeOrders) {
      Map<String, double> mappedStoreSalesWithDate = Map();
      Map<String, int> mappedStoreCancellations = Map();
      Map<String, int> mappedStoreConfirmedOrders = Map();
      Map<String, int> mappedStoreDeliveredOrders = Map();

      int totalCancellations = 0;
      int totalConfirmedOrders = 0;
      int totalDeliveredOrders = 0;

      // total sales
      final totalSales = storeOrders.fold(
          0.0,
          (previousValue, store) =>
              (store.price * store.quantity) + previousValue);

      // detailed sales
      final mappedStoreOrders = storeOrders.groupListsBy((element) =>
          _provideFormattedDate(
              date: DateTime.fromMillisecondsSinceEpoch(
                  element.updatedAt.toInt())));
      mappedStoreOrders.forEach((dateStr, value) {
        mappedStoreSalesWithDate[dateStr] = value.fold(
            0.0,
            (previousValue, store) =>
                (store.price * store.quantity) + previousValue);
        // cancellations
        final currentCancellations = value
            .where((element) =>
                element.status == OrderStatus.CANCELLED ||
                element.status == OrderStatus.REJECTED)
            .length;
        mappedStoreCancellations[dateStr] = currentCancellations;
        totalCancellations += currentCancellations;

        // confirmed orders
        final currentConfirmedOrders = value
            .where((element) => element.status == OrderStatus.APPROVED)
            .length;
        mappedStoreConfirmedOrders[dateStr] = currentConfirmedOrders;
        totalConfirmedOrders += currentConfirmedOrders;

        // delivered Orders
        final currentDeliveredOrders = value
            .where((element) =>
                element.status.index >= OrderStatus.ON_DELIVERY.index)
            .length;
        mappedStoreDeliveredOrders[dateStr] = currentDeliveredOrders;
        totalDeliveredOrders += currentDeliveredOrders;
      });

      // store
      final store = stores.firstWhere((element) => element.id == storeId);
      final report = StoreReports(
          store: store,
          totalSales: totalSales,
          totalCancellations: totalCancellations,
          totalConfirmedOrders: totalConfirmedOrders,
          totalDeliveredOrders: totalDeliveredOrders,
          detailedSales: mappedStoreSalesWithDate,
          detailedCancellations: mappedStoreCancellations,
          detailedConfirmedOrders: mappedStoreConfirmedOrders,
          detailedDeliveredOrders: mappedStoreDeliveredOrders);

      mappedDetailedStoreSales[store] = mappedStoreSalesWithDate;
      mappedStoreTotalSales[store] = totalSales;
      mappedStoreReports[store.id] = report;

      add(ProvideDetailedStoresSalesEvent(
          mapDetailedStoreSales: mappedDetailedStoreSales,
          mapStoreTotalSales: mappedStoreTotalSales,
          mappedStoreReports: mappedStoreReports));
    });
  }

  void requestStoreCharts() {
    if (_stores != null && _orders != null) {
      _provideStoreJoinGroupings(stores: _stores);
      _provideDetailedStoresSales(orders: _orders, stores: _stores);
    }
  }

  void triggerStoreActivation({@required Store store, String deactivationReason}) {
    assert(store != null);
    assert(_selectedStore != null);
    add(TriggerStoreActivation(store: _selectedStore, message: deactivationReason));
  }

  Future<void> _deactivateStore({@required Store store, String deactivationReason}) async {
    assert(store != null);

    // delete products first
    final products =
        await productRepository.loadByCompanyAsync(storeId: store.id);

    products.forEach((product) async {
      await productRepository.delete(id: product.id);
    });

    // delete store
    store.deletedNote = deactivationReason;
    await storeRepository.update(datum: store);
    await storeRepository.delete(id: store.id);

    return Future.value();
  }

  Future<void> _activateStore({@required Store store}) async {
    assert(store != null);

    // update products first
    final products =
        await productRepository.loadByCompanyAsync(storeId: store.id);

    products.forEach((product) async {
      product.deletedAt = null;
      await productRepository.update(datum: product);
    });

    // update store
    await storeRepository.update(datum: store);

    return Future.value();
  }

  void selectStore({@required Store store}) {
    assert(store != null);

    _selectedStore = store;
  }
}

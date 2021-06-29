import 'package:admin_app/bloc/message/message_bloc.dart';
import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/config/app_colors.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/address.dart';
import 'package:admin_app/model/charts/linear_sales.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/widgets/commons.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreScreen extends StatelessWidget {
  final Store store;

  const StoreScreen({Key key, @required this.store})
      : assert(store != null),
        super(key: key);

  @override
  Widget build(BuildContext rootContext) {
    final screenHeight = MediaQuery.of(rootContext).size.height;
    final reportsBloc = BlocProvider.of<ReportsBloc>(rootContext);
    final salesBarChartData =
        _createSalesBarChartDataForStore(reportsBloc, store);
    final cancellationBarChartData =
        _createCancellationsBarChartDataForStore(reportsBloc, store);
    final confirmedOrdersBarCharData =
        _createConfirmedOrdersBarChartDataForStore(reportsBloc, store);
    final deliveredOrdersBarChartData =
        _createDeliveredBarChartDataForStore(reportsBloc, store);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(rootContext),
        ),
        title: Text("${store.name}"),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white, padding: EdgeInsets.only(right: 16.0)),
              onPressed: () {
                if (reportsBloc.selectedStore != null &&
                    reportsBloc.selectedStore.deletedAt == null) {
                  final Store store = reportsBloc.selectedStore;
                  
                  final TextEditingController reasonController =
                  TextEditingController();

                  showConfirmDialog(
                      context: rootContext,
                      title: "You are going to deactivate store ${store.name}",
                      customWidget: Container(
                        height: screenHeight * 0.34,
                        child: Column(
                          children: [
                            Text(
                                "You are going to deactivate store ${store.name}. If this is intentional, please state the reason for deactivating the store."),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              controller: reasonController,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Reason",
                                  hintText:
                                  "This is not required but would be great to tell the store owner what did they did.",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                            )
                          ],
                        ),
                      ),
                      positiveButtonText: "Start deactivation",
                      positiveAction: () => reportsBloc.triggerStoreActivation(store: store, deactivationReason: reasonController.text));
                  return;
                }

                reportsBloc.triggerStoreActivation(store: store);
              },
              child: BlocBuilder<ReportsBloc, ReportsState>(
                  builder: (blocContext, state) {
                String label = "Deactivate";

                if (reportsBloc.selectedStore != null &&
                    reportsBloc.selectedStore.deletedAt != null) {
                  label = "Activate";
                }

                return Text(
                  label,
                );
              }))
        ],
      ),
      body: BlocListener<ReportsBloc, ReportsState>(
        listener: (listenerContext, state) {
          if (state is ReportsLoadingState) {
            if (state.show) {
              showLoadingDialog(listenerContext);
            } else {
              Navigator.of(listenerContext).pop();
            }
          }
        },
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (blocContext, state) {
            final storeTotalSales =
                reportsBloc.mappedStoreTotalSales[store] ?? 0.0;

            final owner = reportsBloc.users
                .firstWhere((element) => element.id == store.ownerId);
            final storeAddress = reportsBloc.addresses
                .firstWhere((element) => element.id == store.addressId);
            final contactNumber = owner.mobileNumber;

            return Stack(
              children: [
                SvgPicture.asset(
                  "assets/images/bg.svg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                SafeArea(
                    child: ListView(children: [
                  Container(
                    padding: DEFAULT_SPACING_FIRST_WIDGET,
                    width: double.infinity,
                    child: titleValue(
                        title: "Owner name: ", value: "${owner.name}"),
                  ),
                  Container(
                    padding: DEFAULT_SPACING_NEXT_WIDGET,
                    width: double.infinity,
                    child: titleValue(
                        title: "Store address: ",
                        value: "${storeAddress.toString()}"),
                  ),
                      Container(
                        padding: DEFAULT_SPACING_NEXT_WIDGET,
                        width: double.infinity,
                        child: titleValue(
                            title: "Contact number: ",
                            value: "${contactNumber.toString()}"),
                      ),
                  Container(
                    padding: DEFAULT_SPACING_NEXT_WIDGET,
                    width: double.infinity,
                    child: titleValue(
                        title: "Total sales to date: ",
                        value: currencyFormat.format(storeTotalSales)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Text(
                      "Overall store sales",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: DEFAULT_SPACING_NEXT_WIDGET,
                    height: 200,
                    child: charts.BarChart(
                      salesBarChartData,
                      animate: true,

                      /// Assign a custom style for the measure axis.
                      ///
                      /// The NoneRenderSpec only draws an axis line (and even that can be hidden
                      /// with showAxisLine=false).
//                      primaryMeasureAxis:
//                      new charts.NumericAxisSpec(
//                          renderSpec: new charts.NoneRenderSpec()),

                      /// This is an OrdinalAxisSpec to match up with BarChart's default
                      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
                      /// other charts).
//                      domainAxis: new charts.OrdinalAxisSpec(
//                        // Make sure that we draw the domain axis line.
//                          showAxisLine: true,
//                          // But don't draw anything else.
//                          renderSpec: new charts.NoneRenderSpec()),

                      // With a spark chart we likely don't want large chart margins.
                      // 1px is the smallest we can make each margin.
//                      layoutConfig: new charts.LayoutConfig(
//                          leftMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          topMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          rightMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          bottomMarginSpec: new charts.MarginSpec.fixedPixel(
//                              0)),
                      // showing item / drawing when clicking
                      behaviors: [
                        // charts.LinePointHighlighter(
                        //     symbolRenderer: CustomCircleSymbolRenderer()
                        // )
                        // Add the sliding viewport behavior to have the viewport center on the
                        // domain that is currently selected.
                        charts.SlidingViewport(),
                        // A pan and zoom behavior helps demonstrate the sliding viewport
                        // behavior by allowing the data visible in the viewport to be adjusted
                        // dynamically.
                        charts.PanAndZoomBehavior(),
                      ],
//                        selectionModels: [
//                          charts.SelectionModelConfig(
//                              changedListener: (charts.SelectionModel model) {
//                                if(model.hasDatumSelection)
//                                  print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
//                              }
//                          )
//                        ]
                      // Set a bar label decorator.
                      // Example configuring different styles for inside/outside:
                      //       barRendererDecorator: new charts.BarLabelDecorator(
                      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                      barRendererDecorator:
                          new charts.BarLabelDecorator<String>(),
                      domainAxis: new charts.OrdinalAxisSpec(
                          viewport: charts.OrdinalViewport(
                              DateTime.now().year.toString(), 6)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Text(
                      "Overall store cancellations",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: DEFAULT_SPACING_NEXT_WIDGET,
                    height: 200,
                    child: charts.BarChart(
                      cancellationBarChartData,
                      animate: true,

                      /// Assign a custom style for the measure axis.
                      ///
                      /// The NoneRenderSpec only draws an axis line (and even that can be hidden
                      /// with showAxisLine=false).
//                      primaryMeasureAxis:
//                      new charts.NumericAxisSpec(
//                          renderSpec: new charts.NoneRenderSpec()),

                      /// This is an OrdinalAxisSpec to match up with BarChart's default
                      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
                      /// other charts).
//                      domainAxis: new charts.OrdinalAxisSpec(
//                        // Make sure that we draw the domain axis line.
//                          showAxisLine: true,
//                          // But don't draw anything else.
//                          renderSpec: new charts.NoneRenderSpec()),

                      // With a spark chart we likely don't want large chart margins.
                      // 1px is the smallest we can make each margin.
//                      layoutConfig: new charts.LayoutConfig(
//                          leftMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          topMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          rightMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          bottomMarginSpec: new charts.MarginSpec.fixedPixel(
//                              0)),
                      // showing item / drawing when clicking
                      behaviors: [
                        // charts.LinePointHighlighter(
                        //     symbolRenderer: CustomCircleSymbolRenderer()
                        // )
                        // Add the sliding viewport behavior to have the viewport center on the
                        // domain that is currently selected.
                        charts.SlidingViewport(),
                        // A pan and zoom behavior helps demonstrate the sliding viewport
                        // behavior by allowing the data visible in the viewport to be adjusted
                        // dynamically.
                        charts.PanAndZoomBehavior(),
                      ],
//                        selectionModels: [
//                          charts.SelectionModelConfig(
//                              changedListener: (charts.SelectionModel model) {
//                                if(model.hasDatumSelection)
//                                  print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
//                              }
//                          )
//                        ]
                      // Set a bar label decorator.
                      // Example configuring different styles for inside/outside:
                      //       barRendererDecorator: new charts.BarLabelDecorator(
                      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                      barRendererDecorator:
                          new charts.BarLabelDecorator<String>(),
                      domainAxis: new charts.OrdinalAxisSpec(
                          viewport: charts.OrdinalViewport(
                              DateTime.now().year.toString(), 6)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Text(
                      "Overall store confirmed orders",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: DEFAULT_SPACING_NEXT_WIDGET,
                    height: 200,
                    child: charts.BarChart(
                      confirmedOrdersBarCharData,
                      animate: true,

                      /// Assign a custom style for the measure axis.
                      ///
                      /// The NoneRenderSpec only draws an axis line (and even that can be hidden
                      /// with showAxisLine=false).
//                      primaryMeasureAxis:
//                      new charts.NumericAxisSpec(
//                          renderSpec: new charts.NoneRenderSpec()),

                      /// This is an OrdinalAxisSpec to match up with BarChart's default
                      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
                      /// other charts).
//                      domainAxis: new charts.OrdinalAxisSpec(
//                        // Make sure that we draw the domain axis line.
//                          showAxisLine: true,
//                          // But don't draw anything else.
//                          renderSpec: new charts.NoneRenderSpec()),

                      // With a spark chart we likely don't want large chart margins.
                      // 1px is the smallest we can make each margin.
//                      layoutConfig: new charts.LayoutConfig(
//                          leftMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          topMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          rightMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          bottomMarginSpec: new charts.MarginSpec.fixedPixel(
//                              0)),
                      // showing item / drawing when clicking
                      behaviors: [
                        // charts.LinePointHighlighter(
                        //     symbolRenderer: CustomCircleSymbolRenderer()
                        // )
                        // Add the sliding viewport behavior to have the viewport center on the
                        // domain that is currently selected.
                        charts.SlidingViewport(),
                        // A pan and zoom behavior helps demonstrate the sliding viewport
                        // behavior by allowing the data visible in the viewport to be adjusted
                        // dynamically.
                        charts.PanAndZoomBehavior(),
                      ],
//                        selectionModels: [
//                          charts.SelectionModelConfig(
//                              changedListener: (charts.SelectionModel model) {
//                                if(model.hasDatumSelection)
//                                  print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
//                              }
//                          )
//                        ]
                      // Set a bar label decorator.
                      // Example configuring different styles for inside/outside:
                      //       barRendererDecorator: new charts.BarLabelDecorator(
                      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                      barRendererDecorator:
                          new charts.BarLabelDecorator<String>(
                              insideLabelStyleSpec: charts.TextStyleSpec(
                                  color: charts.MaterialPalette.black)),
                      domainAxis: new charts.OrdinalAxisSpec(
                          viewport: charts.OrdinalViewport(
                              DateTime.now().year.toString(), 6)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Text(
                      "Overall store delivered orders",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: DEFAULT_SPACING_NEXT_WIDGET,
                    height: 200,
                    child: charts.BarChart(
                      deliveredOrdersBarChartData,
                      animate: true,

                      /// Assign a custom style for the measure axis.
                      ///
                      /// The NoneRenderSpec only draws an axis line (and even that can be hidden
                      /// with showAxisLine=false).
//                      primaryMeasureAxis:
//                      new charts.NumericAxisSpec(
//                          renderSpec: new charts.NoneRenderSpec()),

                      /// This is an OrdinalAxisSpec to match up with BarChart's default
                      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
                      /// other charts).
//                      domainAxis: new charts.OrdinalAxisSpec(
//                        // Make sure that we draw the domain axis line.
//                          showAxisLine: true,
//                          // But don't draw anything else.
//                          renderSpec: new charts.NoneRenderSpec()),

                      // With a spark chart we likely don't want large chart margins.
                      // 1px is the smallest we can make each margin.
//                      layoutConfig: new charts.LayoutConfig(
//                          leftMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          topMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          rightMarginSpec: new charts.MarginSpec.fixedPixel(0),
//                          bottomMarginSpec: new charts.MarginSpec.fixedPixel(
//                              0)),
                      // showing item / drawing when clicking
                      behaviors: [
                        // charts.LinePointHighlighter(
                        //     symbolRenderer: CustomCircleSymbolRenderer()
                        // )
                        // Add the sliding viewport behavior to have the viewport center on the
                        // domain that is currently selected.
                        charts.SlidingViewport(),
                        // A pan and zoom behavior helps demonstrate the sliding viewport
                        // behavior by allowing the data visible in the viewport to be adjusted
                        // dynamically.
                        charts.PanAndZoomBehavior(),
                      ],
//                        selectionModels: [
//                          charts.SelectionModelConfig(
//                              changedListener: (charts.SelectionModel model) {
//                                if(model.hasDatumSelection)
//                                  print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
//                              }
//                          )
//                        ]
                      // Set a bar label decorator.
                      // Example configuring different styles for inside/outside:
                      //       barRendererDecorator: new charts.BarLabelDecorator(
                      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                      barRendererDecorator:
                          new charts.BarLabelDecorator<String>(
                              insideLabelStyleSpec: charts.TextStyleSpec(
                                  color: charts.MaterialPalette.black)),
                      domainAxis: new charts.OrdinalAxisSpec(
                          viewport: charts.OrdinalViewport(
                              DateTime.now().year.toString(), 6)),
                    ),
                  ),
                ]))
              ],
            );
          },
        ),
      ),
    );
  }

  List<charts.Series<LinearSales, String>> _createSalesBarChartDataForStore(
      ReportsBloc reportsBloc, Store store) {
    final List<LinearSales> data = [];
    final mappedSales = reportsBloc.mappedStoreDetailedSales[store];

    if (mappedSales == null) return [];

    mappedSales.forEach((key, value) {
      data.add(LinearSales(key, value));
    });

    return [
      new charts.Series<LinearSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales sales, _) =>
              "${currencyFormat.format(sales.sales)}")
    ];
  }

  List<charts.Series<LinearSales, String>>
      _createCancellationsBarChartDataForStore(
          ReportsBloc reportsBloc, Store store) {
    final List<LinearSales> data = [];
    final report = reportsBloc.mappedDetailedStoreReports[store.id];
    final mappedCancellations = report.detailedCancellations;

    if (mappedCancellations == null) return [];

    mappedCancellations.forEach((key, value) {
      data.add(LinearSales(key, value.toDouble()));
    });

    return [
      new charts.Series<LinearSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales sales, _) =>
              "${currencyFormat.format(sales.sales)}")
    ];
  }

  List<charts.Series<LinearSales, String>>
      _createConfirmedOrdersBarChartDataForStore(
          ReportsBloc reportsBloc, Store store) {
    final List<LinearSales> data = [];
    final report = reportsBloc.mappedDetailedStoreReports[store.id];
    final mappedConfirmedOrders = report.detailedConfirmedOrders;

    if (mappedConfirmedOrders == null) return [];

    mappedConfirmedOrders.forEach((key, value) {
      data.add(LinearSales(key, value.toDouble()));
    });

    return [
      new charts.Series<LinearSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales sales, _) =>
              "${currencyFormat.format(sales.sales)}")
    ];
  }

  List<charts.Series<LinearSales, String>> _createDeliveredBarChartDataForStore(
      ReportsBloc reportsBloc, Store store) {
    final List<LinearSales> data = [];
    final report = reportsBloc.mappedDetailedStoreReports[store.id];
    final mappedDeliveries = report.detailedDeliveredOrders;

    if (mappedDeliveries == null) return [];

    mappedDeliveries.forEach((key, value) {
      data.add(LinearSales(key, value.toDouble()));
    });

    return [
      new charts.Series<LinearSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales sales, _) =>
              "${currencyFormat.format(sales.sales)}")
    ];
  }
}

import 'dart:math';

import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/charts/linear_sales.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/model/store.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext rootContext) {
    final reportsBloc = BlocProvider.of<ReportsBloc>(rootContext);

    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (blocContext, state) {
        final chartData = _createChartData(reportsBloc);

        return ListView(
          children: [
            Container(
              padding: DEFAULT_SPACING_NEXT_WIDGET,
              height: 200,
              child: charts.BarChart(
                chartData,
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
                barRendererDecorator: new charts.BarLabelDecorator<String>(),
                domainAxis: new charts.OrdinalAxisSpec(
                    viewport: charts.OrdinalViewport(
                        DateTime.now().year.toString(), 3)),
              ),
            ),
            // list
            Container(
              margin: EdgeInsets.only(left: 16.0),
              child: Text(
                "Transactions",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            for (var order in reportsBloc.orders) ...[
              OpenContainer(
                  closedColor: Colors.transparent,
                  closedElevation: 0.0,
                  closedBuilder: (containerContext, action) {
                    return ListTile(
                      title: Text("Order id: ${order.id}"),
                      subtitle: Text(
                          "${presentableDateFormat.format(DateTime.fromMillisecondsSinceEpoch(order.updatedAt.toInt()))}\n\nAmount: ${order.price * order.quantity}"),
                      isThreeLine: true,
                    );
                  },
                  openBuilder: (containerContext, action) =>
                      _detailPopUpScreen(containerContext, order: order)),
              Divider()
            ],
          ],
        );
      },
    );
  }

  _detailPopUpScreen(BuildContext context, {Order order}) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("${order.id}"),
      ),
      body: Text("body of user : ${order.id}"),
    );
  }

  List<charts.Series<LinearSales, String>> _createChartData(
      ReportsBloc reportsBloc) {
    final List<LinearSales> data = [];
    reportsBloc.orderDailySales.forEach((key, value) {
      data.add(LinearSales(key, value));
    });

    return [
      new charts.Series<LinearSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales sales, _) =>
              "${currencyFormat.format(sales.sales)}")
    ];
  }
}


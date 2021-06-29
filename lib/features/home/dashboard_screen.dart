import 'dart:math';

import 'package:admin_app/bloc/order/order_bloc.dart';
import 'package:admin_app/bloc/product/product_bloc.dart';
import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/config/app_colors.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/charts/linear_sales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext rootContext) {
    final screenSize = MediaQuery.of(rootContext).size;
    final productBloc = BlocProvider.of<ProductBloc>(rootContext);
    final reportsBloc = BlocProvider.of<ReportsBloc>(rootContext);

    return Container(
      color: Colors.white30,
      child: ListView(
        children: [
          BlocBuilder<ReportsBloc, ReportsState>(builder: (blocContext, state) {
            return Container(
              margin: DEFAULT_SPACING,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _peekHeaderDetail(blocContext,
                      title: "Users",
                      value: "${reportsBloc.users.length}",
                      backgroundColor: AppColors.primary),
                  _peekHeaderDetail(blocContext,
                      title: "Stores",
                      value: "${reportsBloc.stores.length}",
                      backgroundColor: AppColors.orange),
                  _peekHeaderDetail(blocContext,
                      title: "Riders",
                      value: "${reportsBloc.riders.length}",
                      backgroundColor: AppColors.violet),
                ],
              ),
            );
          }),
          BlocBuilder<ReportsBloc, ReportsState>(
              builder: (reportsBlocContext, state) {
                final chartData = _createRandomData(reportsBloc);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: DEFAULT_SPACING_FIRST_WIDGET,
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                            text: "Total combined sales to date: ",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            children: [
                              TextSpan(
                                  text: currencyFormat
                                      .format(reportsBloc.calculateCombinedTotalSales()),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.orange))
                            ]),
                      ),
                    ),
                    Container(
                      padding: DEFAULT_SPACING_NEXT_WIDGET,
                      width: double.infinity,
                      child: Text(
                        "${dateGroupingEnum[reportsBloc.selectedDateGrouping]} sales",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w500),
                      ),
                    ),
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
                        barRendererDecorator:
                            new charts.BarLabelDecorator<String>(),
                        domainAxis: new charts.OrdinalAxisSpec(
                            viewport: charts.OrdinalViewport(
                                DateTime.now().year.toString(), 6)),
                      ),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }

  _peekHeaderDetail(BuildContext context,
      {@required String title, @required String value, Color backgroundColor = AppColors.primary}) {
    assert(title != null);
    assert(value != null);
    assert(backgroundColor != null);

    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          color: backgroundColor),
      padding: EdgeInsets.all(24.0),
      width: screenSize.width * 0.2,
      child: Column(
        children: [
          Text("$value",
              style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          Text("$title",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white))
        ],
      ),
    );
  }

  List<charts.Series<LinearSales, String>> _createRandomData(
      ReportsBloc reportsBloc) {
    final random = new Random();

//    final data = [
//      new LinearSales(0, random.nextInt(100)),
//      new LinearSales(1, random.nextInt(100)),
//      new LinearSales(2, random.nextInt(100)),
//      new LinearSales(3, random.nextInt(100)),
//    ];

    final List<LinearSales> data = [];
    reportsBloc.combinedDailySales.forEach((key, value) {
      data.add(LinearSales(key, value));
    });

//    for (int i = 0; i < 15; i++) {
//      data.add(LinearSales(i.toString(), random.nextInt(10000)));
//    }

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

  List<charts.Series<TimeSeriesSales, DateTime>> _createRandomDataTime() {
    final random = new Random();

    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), random.nextInt(100)),
      new TimeSeriesSales(new DateTime(2017, 9, 26), random.nextInt(100)),
      new TimeSeriesSales(new DateTime(2017, 10, 3), random.nextInt(100)),
      new TimeSeriesSales(new DateTime(2017, 10, 10), random.nextInt(100)),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

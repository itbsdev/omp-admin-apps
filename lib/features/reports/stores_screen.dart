import 'dart:async';

import 'package:admin_app/bloc/common/page_changed_cubit.dart';
import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/config/app_colors.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/features/reports/store_screen.dart';
import 'package:admin_app/model/charts/linear_sales.dart';
import 'package:admin_app/model/store.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class StoresScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final List<bool> _selectedTabs = [true, false, false, false];

  @override
  Widget build(BuildContext rootContext) {
    final screenSize = MediaQuery.of(rootContext).size;
    final screenWidth = screenSize.width * 0.7;
    final reportsBloc = BlocProvider.of<ReportsBloc>(rootContext);

    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (blocContext, state) {
        final barChartData = _createBarChartData(reportsBloc);
        final pieChartData = _createPieChartData(reportsBloc);
        final barChartStoreJoinData = _createBarChartStoreJoinData(reportsBloc);

        return ListView(
          children: [
            Container(
              padding: DEFAULT_SPACING_FIRST_WIDGET,
              width: double.infinity,
              child: RichText(
                text: TextSpan(
                    text: "All store total sales to date: ",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: currencyFormat
                              .format(reportsBloc.calculateAllStoreSales()),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: AppColors.orange))
                    ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                "All store sales",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: DEFAULT_SPACING_NEXT_WIDGET,
              height: 200,
              child: charts.BarChart(
                barChartData,
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
                        DateTime.now().year.toString(), 6)),
              ),
            ),
            Container(
              width: screenWidth,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Sales by Stores",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: DEFAULT_SPACING_NEXT_WIDGET,
                        height: 250,
                        width: screenWidth / 2,
                        child: charts.PieChart(pieChartData,
                            animate: true,
                            behaviors: [
                              new charts.DatumLegend(
                                // Positions for "start" and "end" will be left and right respectively
                                // for widgets with a build context that has directionality ltr.
                                // For rtl, "start" and "end" will be right and left respectively.
                                // Since this example has directionality of ltr, the legend is
                                // positioned on the right side of the chart.
                                position: charts.BehaviorPosition.bottom,
                                // By default, if the position of the chart is on the left or right of
                                // the chart, [horizontalFirst] is set to false. This means that the
                                // legend entries will grow as new rows first instead of a new column.
                                horizontalFirst: false,
                                // This defines the padding around each legend entry.
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0),
                                // Set [showMeasures] to true to display measures in series legend.
                                showMeasures: true,
                                // Configure the measure value to be shown by default in the legend.
                                legendDefaultMeasure:
                                    charts.LegendDefaultMeasure.firstValue,
                                // Optionally provide a measure formatter to format the measure value.
                                // If none is specified the value is formatted as a decimal.
                                measureFormatter: (num value) {
                                  return value == null
                                      ? '-'
                                      : '${currencyFormat.format(value)}';
                                },
                              ),
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.outside)
                                ])),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Store opens",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: DEFAULT_SPACING_NEXT_WIDGET,
                        height: 250,
                        width: screenWidth / 2,
                        child: charts.BarChart(barChartStoreJoinData,
                            animate: true,
                            barRendererDecorator:
                                new charts.BarLabelDecorator<String>(),
                            domainAxis: new charts.OrdinalAxisSpec(
                                viewport: charts.OrdinalViewport(
                                    DateTime.now().year.toString(), 3))),
                      )
                    ],
                  )
                ],
              ),
            ),
            // DefaultTabController(length: 2, child: Column(
            //   children: [
            //     TabBar(tabs: [
            //       Text("1"),
            //       Text("2")
            //     ]),
            //     TabBarView(children: [
            //       Text("this is 1"),
            //       Text("this is 2")
            //     ])
            //   ],
            // )),
            Container(
              height: 200.0,
              margin: DEFAULT_SPACING,
              child: BlocProvider(
                create: (_) => PageChangedCubit(),
                child: BlocBuilder<PageChangedCubit, PageChangedState>(
                  builder: (builderContext, state) {
                    final pageChangedCubit =
                        BlocProvider.of<PageChangedCubit>(builderContext);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ToggleButtons(
                                borderRadius: BorderRadius.circular(8.0),
                                selectedColor: AppColors.primaryLight,
                                selectedBorderColor: AppColors.primary,
                                onPressed: (position) {
                                  print("pressed on $position");
                                  final List<bool> tmpList =
                                      List.filled(_selectedTabs.length, false);
                                  tmpList[position] = true;
                                  _selectedTabs.setAll(0, tmpList);
                                  _pageController.jumpToPage(position);
                                  pageChangedCubit.onPositionChanged(position);
                                },
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("Stores"),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("Cancelled Orders")),
                                  Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("Confirmed Orders")),
                                  Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("Delivered Orders"))
                                ],
                                isSelected: _selectedTabs),
                          ],
                        ),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            children: [
                              ListView.separated(
                                  itemBuilder: (_, position) {
                                    // stores  /total sales
                                    final store = reportsBloc.stores[position];
                                    final report = reportsBloc.mappedDetailedStoreReports[store.id];

                                    return OpenContainer(
                                      tappable: false,
                                        closedColor: Colors.transparent,
                                        closedElevation: 0.0,
                                        closedBuilder:
                                            (containerContext, action) {
                                          return ListTile(
                                            onTap: () {
                                              reportsBloc.selectStore(store: store);
                                              action();
                                            },
                                            contentPadding:
                                                EdgeInsets.only(left: 0),
                                            title: Text("${store.name}"),
                                            subtitle: Text(
                                                "Opened on: ${presentableDateFormat.format(DateTime.fromMillisecondsSinceEpoch(store.createdAt.toInt()))}"),
                                            trailing: Text(
                                                "Total sales: ${currencyFormatPhp.format(report.totalSales)}"),
                                          );
                                        },
                                        openBuilder:
                                            (containerContext, action) =>
                                                StoreScreen(store: store));
                                  },
                                  separatorBuilder: (_, position) => Divider(),
                                  itemCount: reportsBloc.stores.length),
                              ListView.separated(
                                  itemBuilder: (_, position) {
                                    // cancelled orders
                                    final store = reportsBloc.stores[position];
                                    final report = reportsBloc.mappedDetailedStoreReports[store.id];

                                    return OpenContainer(
                                      tappable: false,
                                        closedColor: Colors.transparent,
                                        closedElevation: 0.0,
                                        closedBuilder:
                                            (containerContext, action) {
                                          return ListTile(
                                            onTap: () {
                                              reportsBloc.selectStore(store: store);
                                              action();
                                            },
                                            contentPadding:
                                            EdgeInsets.only(left: 0),
                                            title: Text("${store.name}"),
                                            trailing: Text(
                                                "Cancellations: ${wholeNumberFormat.format(report.totalCancellations)}"),
                                          );
                                        },
                                        openBuilder:
                                            (containerContext, action) =>
                                            StoreScreen(store: store));
                                  },
                                  separatorBuilder: (_, position) => Divider(),
                                  itemCount: reportsBloc.stores.length),
                              ListView.separated(
                                  itemBuilder: (_, position) {
                                    // confirmed orders
                                    final store = reportsBloc.stores[position];
                                    final report = reportsBloc.mappedDetailedStoreReports[store.id];

                                    return OpenContainer(
                                      tappable: false,
                                        closedColor: Colors.transparent,
                                        closedElevation: 0.0,
                                        closedBuilder:
                                            (containerContext, action) {
                                          return ListTile(
                                            onTap: () {
                                              reportsBloc.selectStore(store: store);
                                              action();
                                            },
                                            contentPadding:
                                            EdgeInsets.only(left: 0),
                                            title: Text("${store.name}"),
                                            trailing: Text(
                                                "Confirmed orders: ${wholeNumberFormat.format(report.totalConfirmedOrders)}"),
                                          );
                                        },
                                        openBuilder:
                                            (containerContext, action) =>
                                            StoreScreen(store: store));
                                  },
                                  separatorBuilder: (_, position) => Divider(),
                                  itemCount: reportsBloc.stores.length),
                              ListView.separated(
                                  itemBuilder: (_, position) {
                                    // delivered orders
                                    final store = reportsBloc.stores[position];
                                    final report = reportsBloc.mappedDetailedStoreReports[store.id];

                                    return OpenContainer(
                                        closedColor: Colors.transparent,
                                        closedElevation: 0.0,
                                        closedBuilder:
                                            (containerContext, action) {
                                          return ListTile(
                                            contentPadding:
                                            EdgeInsets.only(left: 0),
                                            title: Text("${store.name}"),
                                            trailing: Text(
                                                "Delivered orders: ${wholeNumberFormat.format(report.totalDeliveredOrders)}"),
                                          );
                                        },
                                        openBuilder:
                                            (containerContext, action) =>
                                            StoreScreen(store: store));
                                  },
                                  separatorBuilder: (_, position) => Divider(),
                                  itemCount: reportsBloc.stores.length),
                            ],
                            onPageChanged: (position) {
                              final List<bool> tmpList =
                                  List.filled(_selectedTabs.length, false);
                              tmpList[position] = true;
                              _selectedTabs.setAll(0, tmpList);
                              _pageController.animateToPage(position,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastLinearToSlowEaseIn);
                              pageChangedCubit.onPositionChanged(position);
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<charts.Series<LinearSales, String>> _createBarChartData(
      ReportsBloc reportsBloc) {
    final List<LinearSales> data = [];
    reportsBloc.orderDailySales.forEach((key, value) {
      final generatedColorStr = AppColors.getRandomStringHexColor();

      data.add(LinearSales(key, value, colorHexStr: generatedColorStr));
    });

    return [
      new charts.Series<LinearSales, String>(
          id: 'Sales',
          colorFn: (LinearSales sales, __) =>
              charts.Color.fromHex(code: sales.colorHexStr),
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales sales, _) =>
              "${currencyFormat.format(sales.sales)}")
    ];
  }

  List<charts.Series<LinearSales, String>> _createPieChartData(
      ReportsBloc reportsBloc) {
    final List<LinearSales> data = [];
    reportsBloc.mappedStoreTotalSales.forEach((store, sale) {
      final generatedColorStr = AppColors.getRandomStringHexColor();

      data.add(LinearSales(store.name, sale, colorHexStr: generatedColorStr));
    });

    print("create pie chart data: ${data.toString()}");

    return [
      new charts.Series<LinearSales, String>(
          id: 'Store sales',
          colorFn: (LinearSales sales, __) =>
              charts.Color.fromHex(code: sales.colorHexStr),
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales sales, _) => "${sales.year}")
    ];
  }

  List<charts.Series<LinearSales, String>> _createBarChartStoreJoinData(
      ReportsBloc reportsBloc) {
    final List<LinearSales> data = [];
    reportsBloc.mappedStoreJoinDate.forEach((key, value) {
      final generatedColorStr = AppColors.getRandomStringHexColor();
      data.add(LinearSales(key, value.length.toDouble(),
          colorHexStr: generatedColorStr));
    });

    return [
      new charts.Series<LinearSales, String>(
          id: 'Store open',
          colorFn: (LinearSales sales, __) =>
              charts.Color.fromHex(code: sales.colorHexStr),
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales sales, _) =>
              "${wholeNumberFormat.format(sales.sales)}")
    ];
  }
}

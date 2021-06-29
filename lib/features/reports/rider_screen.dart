import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/config/app_colors.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/address.dart';
import 'package:admin_app/model/charts/linear_sales.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/widgets/commons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RiderScreen extends StatelessWidget {
  final Rider rider;

  const RiderScreen({Key key, @required this.rider})
      : assert(rider != null),
        super(key: key);

  @override
  Widget build(BuildContext rootContext) {
    final screenHeight = MediaQuery.of(rootContext).size.height;
    final reportsBloc = BlocProvider.of<ReportsBloc>(rootContext);
    final salesBarChartData = _createSalesBarChartDataForRider(reportsBloc, rider);
    final cancellationsBarChartData = _createCancellationsBarChartDataForRider(reportsBloc, rider);
    final deliveriesBarChartData = _createDeliveriesBarChartDataForRider(reportsBloc, rider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(rootContext),
        ),
        title: Text("${rider.name}"),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white, padding: EdgeInsets.only(right: 16.0)),
              onPressed: () {
                if (reportsBloc.selectedRider != null &&
                    reportsBloc.selectedRider.deletedAt == null) {
                  final Rider rider = reportsBloc.selectedRider;

                  final TextEditingController reasonController =
                  TextEditingController();

                  showConfirmDialog(
                      context: rootContext,
                      title: "You are going to deactivate rider ${rider.name}",
                      customWidget: Container(
                        height: screenHeight * 0.34,
                        child: Column(
                          children: [
                            Text(
                                "You are going to deactivate rider ${rider.name}. If this is intentional, please state the reason for deactivating the rider."),
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
                                  "This is not required but would be great to tell the rider what did they did.",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                            )
                          ],
                        ),
                      ),
                      positiveButtonText: "Start deactivation",
                      positiveAction: () => reportsBloc.triggerRiderActivation(rider: rider, deactivationReason: reasonController.text));
                  return;
                }

                reportsBloc.triggerRiderActivation(rider: rider);
              },
              child: BlocBuilder<ReportsBloc, ReportsState>(
                  builder: (blocContext, state) {
                    String label = "Deactivate";

                    if (reportsBloc.selectedRider != null &&
                        reportsBloc.selectedRider.deletedAt != null) {
                      label = "Activate";
                    }

                    return Text(
                      label,
                    );
                  }))
        ],
      ),
      body: BlocListener<ReportsBloc, ReportsState>(listener: (listenerContext, state) {
        if (state is ReportsLoadingState) {
          if (state.show) showLoadingDialog(listenerContext);
          else Navigator.pop(listenerContext);
        }
      },
      child: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (blocContext, state) {
          final storeTotalSales =
              reportsBloc.mappedRiderTotalSales[rider] ?? 0.0;

          final owner = reportsBloc.users
              .firstWhere((element) => element.id == rider.userId);

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
                      child:
                      titleValue(title: "Rider name: ", value: "${owner.name}"),
                    ),
                    Container(
                      padding: DEFAULT_SPACING_NEXT_WIDGET,
                      width: double.infinity,
                      child:
                      titleValue(title: "Contact number: ", value: "${owner.mobileNumber}"),
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
                        "Overall rider sales",
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
                        "Overall rider canellations",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: DEFAULT_SPACING_NEXT_WIDGET,
                      height: 200,
                      child: charts.BarChart(
                        cancellationsBarChartData,
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
                        "Overall rider deliveries",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: DEFAULT_SPACING_NEXT_WIDGET,
                      height: 200,
                      child: charts.BarChart(
                        deliveriesBarChartData,
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
                        "Vehicles",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    BlocBuilder<ReportsBloc, ReportsState>(
                        builder: (blocContext, state) {
                          return Column(
                            children: [
                              for (var vehicle
                              in reportsBloc.getVehiclesByRider(rider: rider)) ...[
                                ListTile(
                                  onTap: () {
                                    print("vehicle media: ${vehicle.mediaUrls[0]}");
                                    showCustomDialog(
                                        context: rootContext,
                                        customWidget: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: vehicle.mediaUrls[0],
                                          progressIndicatorBuilder:
                                              (ctx, url, progress) =>
                                              Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                        ));
                                  },
                                  title: Text(vehicle.toString()),
                                  subtitle: RichText(
                                    text: TextSpan(
                                        text: "${vehicle.plateNumber}\n",
                                        style: TextStyle(color: Colors.black54),
                                        children: [
                                          TextSpan(
                                              text: vehicleTypeEnumMap[vehicle.type],
                                              style: TextStyle(fontSize: 12.0))
                                        ]),
                                  ),
                                  isThreeLine: true,
                                ),
                                Divider(),
                              ]
                            ],
                          );
                        })
                  ]))
            ],
          );
        },
      ),),
    );
  }

  List<charts.Series<LinearSales, String>> _createSalesBarChartDataForRider(
      ReportsBloc reportsBloc, Rider rider) {
    final List<LinearSales> data = [];
    final mappedSales = reportsBloc.mappedRiderDetailedSales[rider];

    if (mappedSales == null) return [];

    mappedSales.forEach((key, value) {
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

  List<charts.Series<LinearSales, String>> _createCancellationsBarChartDataForRider(
      ReportsBloc reportsBloc, Rider rider) {
    final List<LinearSales> data = [];
    final reports = reportsBloc.mappedRiderReports[rider.id];

    if (reports == null) return [];

    reports.detailedCancellations.forEach((key, value) {
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
          "${wholeNumberFormat.format(sales.sales)}")
    ];
  }

  List<charts.Series<LinearSales, String>> _createDeliveriesBarChartDataForRider(
      ReportsBloc reportsBloc, Rider rider) {
    final List<LinearSales> data = [];
    final reports = reportsBloc.mappedRiderReports[rider.id];

    if (reports == null) return [];

    reports.detailedDeliveredOrders.forEach((key, value) {
      data.add(LinearSales(key, value.toDouble()));
    });

    return [
      new charts.Series<LinearSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales sales, _) =>
          "${wholeNumberFormat.format(sales.sales)}")
    ];
  }
}

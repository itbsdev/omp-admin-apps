import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/config/app_colors.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/charts/linear_sales.dart';
import 'package:admin_app/model/user.dart';
import 'package:admin_app/widgets/commons.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class UsersDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext rootContext) {
    final screenSize = MediaQuery.of(rootContext).size;
    final screenWidth = screenSize.width * 0.7;
    final reportsBloc = BlocProvider.of<ReportsBloc>(rootContext);

    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (blocContext, state) {
        final pieChartUserAgeGroupData = _createPieChartDataForUserAgeGroup(reportsBloc);
        final pieChartUserMerchantRiderGroupData = _createPieChartDataForUserMerchantRiderGroup(reportsBloc);
        final pieChartUserGenderGroupData = _createPieChartDataForUserGenderGroup(reportsBloc);

        return ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.0, top: 16.0),
              child: titleValue(title: "Total registered users: ", value: "${reportsBloc.users.length}"),
            ),
            SizedBox(height: 8.0,),
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
                          "Merchants vs. Riders",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        height: 350,
                        width: screenWidth / 0.92,
                        child: charts.PieChart(pieChartUserMerchantRiderGroupData,
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
                                      : '${wholeNumberFormat.format(value)}';
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
                ],
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
                          "Age group",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: DEFAULT_SPACING_NEXT_WIDGET,
                        height: 250,
                        width: screenWidth / 2,
                        child: charts.PieChart(pieChartUserAgeGroupData,
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
                                      : '${wholeNumberFormat.format(value)}';
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
                          "Gender group",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: DEFAULT_SPACING_NEXT_WIDGET,
                        height: 250,
                        width: screenWidth / 2,
                        child: charts.PieChart(pieChartUserGenderGroupData,
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
                                      : '${wholeNumberFormat.format(value)}';
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
                ],
              ),
            ),
            // list
            Container(
              margin: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                "Users",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            for (var user in reportsBloc.users) ...[
              OpenContainer(
                closedColor: Colors.transparent,
                closedElevation: 0.0,
                closedBuilder: (containerContext, action) {
                  return ListTile(
                    onTap: () {
                      action();
                    },
                    title: Text("${user.name}"),
                    subtitle: Text(
                        "Registered on: ${presentableDateFormat.format(DateTime.fromMillisecondsSinceEpoch(user.createdAt.toInt()))}"),
                  );
                },
                openBuilder: (containerContext, action) {
                  return Container();
                },
                tappable: false,),
              Divider()
            ],
          ],
        );
      },
    );
  }

  List<charts.Series<LinearSales, String>> _createPieChartDataForUserAgeGroup(
      ReportsBloc reportsBloc) {
    final List<LinearSales> data = [];
    reportsBloc.mappedUserGroupedByAge.forEach((key, users) {
      final generatedColorStr = AppColors.getRandomStringHexColor();

      data.add(LinearSales(key, users.length.toDouble(), colorHexStr: generatedColorStr));
    });

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

  List<charts.Series<LinearSales, String>> _createPieChartDataForUserMerchantRiderGroup(
      ReportsBloc reportsBloc) {
    final List<LinearSales> data = [];
    reportsBloc.mappedUserGroupedByMerchantRider.forEach((key, users) {
      final generatedColorStr = AppColors.getRandomStringHexColor();
      data.add(LinearSales(key, users.length.toDouble(), colorHexStr: generatedColorStr));
    });
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

  List<charts.Series<LinearSales, String>> _createPieChartDataForUserGenderGroup(
      ReportsBloc reportsBloc) {
    final List<LinearSales> data = [];
    reportsBloc.mappedUserGroupedByGender.forEach((gender, users) {
      final generatedColorStr = AppColors.getRandomStringHexColor();

      data.add(LinearSales(genderEnumMap[gender], users.length.toDouble(), colorHexStr: generatedColorStr));
    });

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
}

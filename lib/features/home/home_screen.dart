import 'package:admin_app/bloc/common/page_changed_cubit.dart';
import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/bloc/settings/settings_bloc.dart';
import 'package:admin_app/config/app_colors.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/features/home/dashboard_screen.dart';
import 'package:admin_app/features/product_categories/product_categories_screen.dart';
import 'package:admin_app/features/reports/deliveries_screen.dart';
import 'package:admin_app/features/reports/orders_screen.dart';
import 'package:admin_app/features/reports/riders_screen.dart';
import 'package:admin_app/features/reports/stores_screen.dart';
import 'package:admin_app/features/reports/users_dashboard.dart';
import 'package:admin_app/features/requests/requests_screen.dart';
import 'package:admin_app/features/settings/app_settings_screen.dart';
import 'package:admin_app/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  static navigate(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomeScreen(),
            settings: RouteSettings(name: "/home")),
        (rt) => false);
  }

  final List<String> _screenTitles = [
    "Dashboard",
    "Users",
    "Stores",
    "Riders",
    "Orders",
    "Deliveries",
    "Product Categories",
    "Requests",
    "Admin Settings",
    "App Settings"
  ];

  @override
  Widget build(BuildContext rootContext) {
    final reportsBloc = BlocProvider.of<ReportsBloc>(rootContext);
    final settingsBloc = BlocProvider.of<SettingsBloc>(rootContext);

    return BlocProvider<PageChangedCubit>(
        create: (blocContext) => PageChangedCubit(),
        child: BlocBuilder<PageChangedCubit, PageChangedState>(
            builder: (blocContext, state) {
          final pageBloc = BlocProvider.of<PageChangedCubit>(blocContext);
          return Row(
            children: [
              Drawer(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      height: 148.0,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/images/bg.svg",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Center(
                            child: Text(
                              "Smart City",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    ListTile(
                      leading: Icon(Icons.dashboard_rounded),
                      title: Text('Dashboard'),
                      selected: state.position == 0,
                      onTap: () => pageBloc.onPositionChanged(0),
                    ),
                    ListTile(
                      leading: Icon(Icons.people_rounded),
                      title: Text('Users'),
                      selected: state.position == 1,
                      onTap: () => pageBloc.onPositionChanged(1),
                    ),
                    ListTile(
                      leading: Icon(Icons.storefront_rounded),
                      title: Text('Stores'),
                      selected: state.position == 2,
                      onTap: () {
                        reportsBloc.requestStoreCharts();
                        pageBloc.onPositionChanged(2);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.motorcycle_rounded),
                      title: Text('Riders'),
                      selected: state.position == 3,
                      onTap: () => pageBloc.onPositionChanged(3),
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.dashboard_rounded),
                    //   title: Text('Orders'),
                    //   selected: state.position == 4,
                    //   onTap: () => pageBloc.onPositionChanged(4),
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.dashboard_rounded),
                    //   title: Text('Deliveries'),
                    //   selected: state.position == 5,
                    //   onTap: () => pageBloc.onPositionChanged(5),
                    // ),
                    ListTile(
                      leading: Icon(Icons.category_rounded),
                      title: Text('Product Categories'),
                      selected: state.position == 6,
                      onTap: () => pageBloc.onPositionChanged(6),
                    ),
                    ListTile(
                      leading: Icon(Icons.category_rounded),
                      title: Text("Requests"),
                      selected: state.position == 7,
                      onTap: () => pageBloc.onPositionChanged(7),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text(
                        "Settings",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings_applications_rounded),
                      title: Text('Admin Settings'),
                      selected: state.position == 8,
                      onTap: () {
                        settingsBloc.loadLatest();
                        pageBloc.onPositionChanged(8);
                      },
                    ),
                    // uncomment when available
                    // ListTile(
                    //   leading: Icon(Icons.settings_applications_rounded),
                    //   title: Text('App Settings'),
                    //   selected: state.position == 9,
                    //   onTap: () {
                    //     pageBloc.onPositionChanged(9);
                    //   },
                    // ),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 1,
              ),
              Expanded(
                  child: Scaffold(
                appBar: AppBar(
                  title: Text(_screenTitles[state.position]),
                  actions: [
                    if (state.position >= 0 && state.position <= 5)
                      BlocBuilder<ReportsBloc, ReportsState>(builder: (blocContext, state) {
                        return _calendarActionButton(context: rootContext, reportsBloc: reportsBloc);
                      }),
                    // IconButton(icon: Icon(Icons.filter_list_rounded), onPressed: () => print("date range")),
                    // IconButton(icon: Icon(Icons.sort_rounded), onPressed: () => print("date range")),
                    if (state.position >= 0 && state.position <= 5)
                      PopupMenuButton(
                        itemBuilder: (popupContext) => [
                          PopupMenuItem(
                            child: _popupCustomItem(reportsBloc,
                                label:
                                    "${dateGroupingEnum[DateGrouping.DAILY]}",
                                selected: reportsBloc.selectedDateGrouping ==
                                    DateGrouping.DAILY),
                            value: DateGrouping.DAILY,
                          ),
                          PopupMenuItem(
                            child: _popupCustomItem(reportsBloc,
                                label:
                                    "${dateGroupingEnum[DateGrouping.WEEKLY]}",
                                selected: reportsBloc.selectedDateGrouping ==
                                    DateGrouping.WEEKLY),
                            value: DateGrouping.WEEKLY,
                          ),
                          PopupMenuItem(
                            child: _popupCustomItem(reportsBloc,
                                label:
                                    "${dateGroupingEnum[DateGrouping.MONTHLY]}",
                                selected: reportsBloc.selectedDateGrouping ==
                                    DateGrouping.MONTHLY),
                            value: DateGrouping.MONTHLY,
                          ),
                          PopupMenuItem(
                            child: _popupCustomItem(reportsBloc,
                                label:
                                    "${dateGroupingEnum[DateGrouping.YEARLY]}",
                                selected: reportsBloc.selectedDateGrouping ==
                                    DateGrouping.YEARLY),
                            value: DateGrouping.YEARLY,
                          ),
                        ],
                        icon: Icon(Icons.wysiwyg_rounded),
                        offset: Offset(0, 40),
                        tooltip: "Date grouping",
                        onSelected: (DateGrouping grouping) =>
                            reportsBloc.setDateGrouping(grouping: grouping),
                      ),
                  ],
                ),
                extendBodyBehindAppBar: true,
                extendBody: true,
                body: Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/images/bg.svg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    SafeArea(child: page(pageNumber: state.position))
                  ],
                ),
              ))
            ],
          );
        }));
  }

  Widget page({int pageNumber}) {
    switch (pageNumber) {
      case 0:
        return DashboardScreen();
      case 1:
        return UsersDashboardScreen();
      case 2:
        return StoresScreen();
      case 3:
        return RidersScreen();
      // case 4:
      //   return OrdersScreen();
      // case 5:
      //   return DeliveriesScreen();
      case 6:
        return ProductCategoriesScreen();
      case 7:
        return RequestsScreen();
      case 8:
        return SettingsScreen();
      case 9:
        return AppSettingsScreen();
      default:
        return Container();
    }
  }

  Widget _popupCustomItem(ReportsBloc reportsBloc,
      {String label, bool selected = false}) {
    assert(label != null && label.isNotEmpty);

    return Row(
      children: [
        Text("$label"),
        SizedBox(
          width: 4,
        ),
        Icon(
          Icons.check_circle_rounded,
          size: 20.0,
          color: selected ? AppColors.green70 : Colors.white,
        ),
      ],
    );
  }

  Widget _calendarActionButton(
      {@required BuildContext context, @required ReportsBloc reportsBloc}) {
    assert(context != null);
    assert(reportsBloc != null);

    if (reportsBloc.selectedStartDate != null &&
        reportsBloc.selectedEndDate != null) {
      return PopupMenuButton(
        itemBuilder: (builderContext) => [
          PopupMenuItem(
            child: Row(
              children: [
                Icon(
                  Icons.close_rounded,
                  size: 20.0,
                  color: AppColors.red,
                ),
                SizedBox(
                  width: 4,
                ),
                Text("Clear"),
              ],
            ),
            value: "clear",
          ),
          PopupMenuItem(
            child: Row(
              children: [
                Icon(
                  Icons.date_range_rounded,
                  size: 20.0,
                  color: Colors.black87,
                ),
                SizedBox(
                  width: 4,
                ),
                Text("Update date")
              ],
            ),
            value: "update-date",
          )
        ],
        onSelected: (String value) {
          switch (value) {
            case "clear":
              reportsBloc.clearDates();
              break;
            case "update-date":
              _showDateRangePicker(context: context, reportsBloc: reportsBloc);
              break;
          }
        },
        icon: Icon(Icons.date_range_rounded),
      );
    }

    return IconButton(
        icon: Icon(Icons.date_range_rounded),
        onPressed: () =>
            _showDateRangePicker(context: context, reportsBloc: reportsBloc));
  }

  void _showDateRangePicker(
      {@required BuildContext context,
      @required ReportsBloc reportsBloc}) async {
    assert(context != null);
    assert(reportsBloc != null);

    final DateTimeRange dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(DateTime.now().year + 2, 12),
    );
    reportsBloc.setSelectedDates(start: dateRange.start, end: dateRange.end);
  }
}

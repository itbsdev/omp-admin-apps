import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/model/delivery.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/model/store.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext rootContext) {
    final reportsBloc = BlocProvider.of<ReportsBloc>(rootContext);

    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (blocContext, state) {
        return ListView.separated(
            itemBuilder: (itemContext, index) {
              final delivery = reportsBloc.deliveries[index];

              return OpenContainer(
                  closedColor: Colors.transparent,
                  closedElevation: 0.0,
                  closedBuilder: (containerContext, action) {
                    return ListTile(
                      title: Text("${delivery.id}"),
                    );
                  },
                  openBuilder: (containerContext, action) => _detailPopUpScreen(
                      containerContext,
                      delivery: delivery,
                      position: index));
            },
            separatorBuilder: (itemContext, index) => Divider(),
            itemCount: reportsBloc.deliveries.length);
      },
    );
  }

  _detailPopUpScreen(BuildContext context, {Delivery delivery, int position}) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("${delivery.id}"),
      ),
      body: Text("body of user : ${delivery.id}"),
    );
  }
}

import 'package:admin_app/config/extensions.dart';
import 'package:flutter/material.dart';

class AppSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: DEFAULT_SPACING,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rider features", style: TextStyle(fontSize: 16.0),),
          Divider(thickness: 1,)
        ],
      ),
    );
  }

}

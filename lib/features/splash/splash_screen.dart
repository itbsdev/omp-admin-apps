import 'package:admin_app/features/login/login_screen.dart';
import 'package:admin_app/widgets/commons.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext rootContext) {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 2000)),
        builder: (builderContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 100)),
                builder: (builderContext2, snapshot2) {
              return LoginScreen();
            });
          }

          return _defaultScreen();
        });
  }

  Widget _defaultScreen() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          provideSvgLocalImage(assetPath: "assets/images/bg.svg"),
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}

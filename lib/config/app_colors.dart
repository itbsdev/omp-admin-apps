import 'dart:math';

/// All util classes, extension functions should be placed here in
/// this file


import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0D64F7);
  static const Color primaryLight = Color(0xFF82AEF7);
  static const Color yellow = Color(0xFFf7e40d);
  static const Color yellowLight = Color(0xFFF7ED82);
  static const Color orange = Color(0xFFF79D0D);
  static const Color orangeLight = Color(0xFFF7CA82);
  static const Color violet = Color(0xFF790DF7);
  static const Color violetLight = Color(0xFFB992F7);
  static const Color veryLightGrey = Color(0xFFEDEDED);
  static const Color green = Color(0xFF23DF2B);
  static const Color green70 = Color(0xB323DF2B);
  static const Color green256 = Color(0x8F93FF97);
  static const Color red = Color(0xFFFF4F4F);
  static const Color lightGray = Color(0xB3EFEFEF);
  static const Color mintGreen = Color(0xFF03DAC5);

  static final primaryPalette = createMaterialColor(primary);


  /// source: https://medium.com/@filipvk/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  static String getRandomStringHexColor() {
    final random = Random();
    final colors = [
      "F0D64F7",
      "Ff7e40d",
      "FF79D0D",
      "F790DF7",
      "F23DF2B",
      "FFF4F4F",
      "F03DAC5",
    ];

    return colors[random.nextInt(colors.length)];
  }
}

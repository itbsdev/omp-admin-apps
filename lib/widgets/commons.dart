import 'dart:math';

import 'package:admin_app/config/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

Widget provideSvgLocalImage({String assetPath}) {
  // if (kIsWeb)
  //   return Image.network(assetPath, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);

  return SvgPicture.asset(
    assetPath,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
  );
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.FillPatternType fillPattern,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
            bounds.height + 10),
        fill: charts.Color.white);
    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(TextElement("1", style: textStyle), (bounds.left).round(),
        (bounds.top - 28).round());
  }
}

RichText titleValue(
    {@required String title,
    @required String value,
    double titleFontSize = 20.0,
    double valueFontSize = 16,
    Color titleColor = Colors.black,
    Color valueColor = AppColors.orange}) {
  assert(title != null);
  assert(value != null);

  return RichText(
    text: TextSpan(
        text: "$title",
        style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w500,
            color: titleColor),
        children: [
          TextSpan(
              text: value,
              style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w400,
                  color: valueColor))
        ]),
  );
}

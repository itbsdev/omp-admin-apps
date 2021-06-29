import 'dart:io';
import 'dart:math';

import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/config/app_colors.dart';
import 'package:admin_app/model/delivery.dart';
import 'package:admin_app/model/order.dart';
import 'package:admin_app/model/rider.dart';
import 'package:admin_app/model/vehicle.dart';
import 'package:week_of_year/week_of_year.dart';

const DEFAULT_BANNER_HEIGHT = 200.0;
const DEFAULT_SPACE_MARGIN = 16.0;
const DEFAULT_SPACE_MARGIN_HALF = 8.0;
const DEFAULT_SPACING = EdgeInsets.all(DEFAULT_SPACE_MARGIN);
const DEFAULT_SPACING_TOP_BOTTOM_HALF = EdgeInsets.only(
    left: DEFAULT_SPACE_MARGIN,
    top: 12,
    right: DEFAULT_SPACE_MARGIN,
    bottom: 12);
const DEFAULT_SPACING_NEXT_WIDGET = EdgeInsets.only(
    left: DEFAULT_SPACE_MARGIN,
    bottom: DEFAULT_SPACE_MARGIN_HALF,
    right: DEFAULT_SPACE_MARGIN);
const DEFAULT_SPACING_FIRST_WIDGET = EdgeInsets.only(
    top: DEFAULT_SPACE_MARGIN,
    left: DEFAULT_SPACE_MARGIN,
    bottom: DEFAULT_SPACE_MARGIN_HALF,
    right: DEFAULT_SPACE_MARGIN);
const DEFAULT_SPACING_HALF = EdgeInsets.all(DEFAULT_SPACE_MARGIN_HALF);
const CARD_TEXT_PADDING = EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0);
const SAVED_NO_POSITION = -999;
const DEFAULT_COUNTRY = "Philippines";
const BASE_FIREBASE_FUNCTIONS_API_URL =
    "https://us-central1-online-market-place-delivery.cloudfunctions.net/api";
const orderStatusEnumMap = {
  OrderStatus.PENDING: 'PENDING',
  OrderStatus.SUBMITTED: 'SUBMITTED',
  OrderStatus.APPROVED: 'APPROVED',
  OrderStatus.REJECTED: 'REJECTED',
  OrderStatus.CANCELLED: 'CANCELLED',
  OrderStatus.ON_DELIVERY: 'ON_DELIVERY',
  OrderStatus.DELIVERED: 'DELIVERED',
  OrderStatus.COMPLETE: 'COMPLETE',
};

const orderTransactionList = [OrderStatus.SUBMITTED, OrderStatus.APPROVED];

const orderHistoryList = [
  OrderStatus.COMPLETE,
  OrderStatus.REJECTED,
  OrderStatus.ON_DELIVERY,
  OrderStatus.DELIVERED
];

const orderSalesTransactionList = [
  OrderStatus.COMPLETE,
  OrderStatus.APPROVED,
  OrderStatus.ON_DELIVERY,
  OrderStatus.DELIVERED
];

const paymentMethodEnumMap = {
  PaymentMethod.COD: 'COD',
  PaymentMethod.OVER_THE_COUNTER: 'OVER_THE_COUNTER',
  PaymentMethod.WEB_BANKING: 'WEB_BANKING',
  PaymentMethod.DEBIT_CARDS: 'DEBIT_CARDS',
  PaymentMethod.E_WALLET: 'E_WALLET',
};

const productPublishEnumMap = {
  ProductPublish.onlineMarket: 'Online Market',
  ProductPublish.marketToHome: 'Market to Home Delivery',
  ProductPublish.onlineMarketDeselect: 'onlineMarketDeselect',
  ProductPublish.marketToHomeDeselect: 'marketToHomeDeselect',
};

const vehicleTypeEnumMap = {
  VehicleType.BIKE: 'BIKE',
  VehicleType.MOTORCYCLE: 'MOTORCYCLE',
  VehicleType.SEDAN: 'SEDAN',
  VehicleType.AUV: 'AUV',
  VehicleType.PICKUP: 'PICKUP',
  VehicleType.SUV: 'SUV',
  VehicleType.TRUCK: 'TRUCK',
};

const riderServiceTypeEnumMap = {
  RiderServiceType.PADALA: 'PADALA',
  RiderServiceType.PABILI: 'PABILI',
  RiderServiceType.PASAKAY: 'PASAKAY',
  RiderServiceType.ORDER: 'ORDER',
};

const deliveryStatusEnumMap = {
  DeliveryStatus.REQUESTING: 'REQUESTING',
  DeliveryStatus.ACCEPTED: 'ACCEPTED',
  DeliveryStatus.PICKED_UP: 'PICKED_UP',
  DeliveryStatus.ON_THE_WAY: 'ON_THE_WAY',
  DeliveryStatus.WITHIN_VICINITY: 'WITHIN_VICINITY',
  DeliveryStatus.COMPLETED: 'COMPLETED',
  DeliveryStatus.CANCELLED: 'CANCELLED',
};

const dateGroupingEnum = {
  DateGrouping.DAILY: "Daily",
  DateGrouping.WEEKLY: "Weekly",
  DateGrouping.MONTHLY: "Monthly",
  DateGrouping.YEARLY: "Yearly",
};

const genderEnumMap = {
  Gender.MALE: 'MALE',
  Gender.FEMALE: 'FEMALE',
};

final List<DeliveryStatus> noRiderStatus = [
  DeliveryStatus.REQUESTING,
  DeliveryStatus.CANCELLED
];

final presentableDateFormat = DateFormat("EEEE, MMM-dd-yyyy");
final dailyDateFormat = DateFormat("MMM-dd-yyyy");
final monthlyDateFormat = DateFormat("MMM-yyyy");
final yearlyDateFormat = DateFormat("yyyy");
final universalDateFormat = DateFormat("yyyy-MM-dd");

String weeklyDateFormat(DateTime date) {
  final weekOfYear = date.weekOfYear;
  final year = date.year;

  return "Week $weekOfYear-$year";
}

final currencyFormat = NumberFormat.currency(name: "", decimalDigits: 2);
final currencyFormatPhp = NumberFormat.currency(symbol: "PHP ", decimalDigits: 2);
final wholeNumberFormat = NumberFormat("###,###,###");
final decimalNumberFormat = NumberFormat("###,###,###.##");

final defaultNumericDecimalFormatters = [
  FilteringTextInputFormatter.deny(new RegExp('[\\-|\\ ]')),
  FilteringTextInputFormatter.allow(new RegExp(r"\d+([\.]\d+)?"))
];

final defaultNumericFormatters = [
  FilteringTextInputFormatter.deny(new RegExp('[\\-|\\ ]')),
  FilteringTextInputFormatter.allow(new RegExp(r"\d+([\.]\d+)?")),
  FilteringTextInputFormatter.deny(new RegExp('[\\-|\\ |\\.|\\,]'))
];

showLoadingDialog(BuildContext context) {
  final dialog = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7),
            child: Text("Loading... Please wait")),
      ],
    ),
  );

  showDialog(
      context: context,
      builder: (context) => dialog,
      barrierDismissible: false);
}

showSimpleDialog(
    {@required BuildContext context, @required String message, String title}) {
  assert(context != null);
  assert(message != null && message.isNotEmpty);

  final dialog = AlertDialog(
    title: title != null && title.isNotEmpty ? Text(title) : null,
    content: Text(message),
    actions: [
      FlatButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
    ],
  );

  showDialog(context: context, builder: (builderContext) => dialog);
}

showConfirmDialog({
  @required BuildContext context,
  String message,
  String title,
  Widget customWidget,
  String positiveButtonText = "OK",
  String negativeButtonText = "Cancel",
  String neutralButtonText,
  VoidCallback positiveAction,
  VoidCallback negativeAction,
  VoidCallback neutralButtonAction
}) {
  assert(context != null);

  if (customWidget == null && (message == null || message.isEmpty)) {
    throw Exception("Please show a message or a custom view for this dialog");
  }

  final dialog = AlertDialog(
    title: title == null ? Container() : Text(title),
    content: customWidget ?? Text(message),
    actions: [
      if (neutralButtonText != null && neutralButtonText.isNotEmpty)
        TextButton(
          onPressed: () {
            if (neutralButtonAction != null) {
              neutralButtonAction();
            }

            Navigator.pop(context);
          },
          child: Text(
            neutralButtonText ?? "More",
            style: TextStyle(color: Colors.red),
          ),
        ),
      TextButton(
        onPressed: () {
          if (negativeAction != null) {
            negativeAction();
          }
          Navigator.pop(context);
        },
        child: Text(
          negativeButtonText ?? "Cancel",
          style: TextStyle(color: Colors.red),
        ),
      ),
      TextButton(
        onPressed: () {
          if (positiveAction != null) {
            positiveAction();
          }
          Navigator.pop(context);
        },
        child: Text(
          positiveButtonText ?? "Ok",
          style: TextStyle(color: AppColors.primary),
        ),
      ),

    ],
  );

  showDialog(context: context, builder: (builderContext) => dialog);
}

showCustomDialog({ @required BuildContext context, Widget customWidget }) {
  assert(context != null);

  final dialog = AlertDialog(
    content: customWidget,
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text("CLOSE"))
    ],
  );

  showDialog(context: context, builder: (_) => dialog);
}

String generateId() {
  final chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  var autoId = "";
  final random = Random();

  for (var i = 0; i < 10; i++) {
    var charIndex = random.nextInt(chars.length);

    autoId += chars[charIndex];
  }

  return autoId;
}

getMapsApiKey() {
  if (Platform.isAndroid) return "AIzaSyDm7SLurt6cQbO35Pra1pUFjv8-cgE0N4k";
  if (Platform.isIOS) return "AIzaSyDNiG0mG4z2d-JcXgCElRDtliQmZkJSXrI";

  return "AIzaSyAdA1IS0nHJfmi5juha116Dl960MomXXdg";
}

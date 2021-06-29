import 'package:admin_app/bloc/settings/settings_bloc.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends StatelessWidget {
  // order
  final TextEditingController _baseOrderDeliveryChargeController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _pricePerWeightController =
      TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _pricePerVolumeController =
      TextEditingController();

  // delivery
  final TextEditingController _baseDeliveryDeliveryChargeController =
      TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _pricePerDistanceController =
      TextEditingController();
  final TextEditingController _bikeChargeController = TextEditingController();
  final TextEditingController _motorCycleChargeController =
      TextEditingController();
  final TextEditingController _sedanController = TextEditingController();
  final TextEditingController _auvController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _suvController = TextEditingController();
  final TextEditingController _truckController = TextEditingController();

  String version = "1.0";

  void _assignValues(SettingsBloc settingsBloc) {
    if (settingsBloc.latestAdminSettings != null) {
      version = settingsBloc.latestAdminSettings.version;
      settingsBloc.latestAdminSettings.items.forEach((element) {
        switch (element.name) {
          case AdminSettingsItemFields.WEIGHT:
            _weightController.text = element.value.toString();
            break;
          case AdminSettingsItemFields.PRICE_PER_WEIGHT:
            _pricePerWeightController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.VOLUME:
            _volumeController.text = element.value.toString();
            break;
          case AdminSettingsItemFields.PRICE_PER_VOLUME:
            _pricePerVolumeController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.DISTANCE:
            _distanceController.text = element.value.toString();
            break;
          case AdminSettingsItemFields.PRICE_PER_DISTANCE:
            _pricePerDistanceController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.PRICE_PERCENTAGE:
            break;
          case AdminSettingsItemFields.BIKE_CHARGE:
            _bikeChargeController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.MOTORCYCLE_CHARGE:
            _motorCycleChargeController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.SEDAN_CHARGE:
            _sedanController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.AUV_CHARGE:
            _auvController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.PICKUP_CHARGE:
            _pickupController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.SUV_CHARGE:
            _suvController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.TRUCK_CHARGE:
            _truckController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.BASE_DELIVERY_CHARGE:
            _baseDeliveryDeliveryChargeController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
          case AdminSettingsItemFields.BASE_ORDER_DELIVERY_CHARGE:
            _baseOrderDeliveryChargeController.text = currencyFormat.format(num.parse(element.value.toString()));
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext rootContext) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(rootContext);

    return BlocListener<SettingsBloc, SettingsState>(
      listener: (listenerContext, state) {
        if (settingsBloc.latestAdminSettings != null) {
          _assignValues(settingsBloc);

          if (state is SettingsErrorState) {
            if (state.message.isNotEmpty) {
              ScaffoldMessenger.of(listenerContext)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          } else if (state is SettingsSuccessState) {
            if (state.message != null && state.message.isNotEmpty) {
              ScaffoldMessenger.of(listenerContext)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          }
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (blocContext, state) {
            _assignValues(settingsBloc);
        return ListView(
          children: [
            Text("Admin Settings version: $version"),
            _orderDeliveryDetails(),
            SizedBox(
              height: 16.0,
            ),
            _deliveryDeliveryDetails(),
            Container(
              margin: DEFAULT_SPACING,
              child: ElevatedButton(
                  onPressed: () => settingsBloc.saveAdminSettings(
                      baseOrderDeliveryCharge:
                          _baseOrderDeliveryChargeController.text,
                      weight: _weightController.text,
                      pricePerWeight: _pricePerWeightController.text,
                      volume: _volumeController.text,
                      pricePerVolume: _pricePerVolumeController.text,
                      baseDeliveryDeliveryCharge:
                          _baseDeliveryDeliveryChargeController.text,
                      distance: _distanceController.text,
                      pricePerDistance: _pricePerDistanceController.text,
                      bikeCharge: _bikeChargeController.text,
                      motorcycleCharge: _motorCycleChargeController.text,
                      sedanCharge: _sedanController.text,
                      auvCharge: _auvController.text,
                      pickupCharge: _pickupController.text,
                      suvCharge: _suvController.text,
                      truckCharge: _truckController.text),
                  child: Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text("SAVE"),
                  )),
            )
          ],
        );
      }),
    );
  }

  Widget _orderDeliveryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: DEFAULT_SPACE_MARGIN, left: DEFAULT_SPACE_MARGIN),
          child: Text(
            "Order Delivery Charges",
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
          ),
        ),
        Divider(
          height: 8.0,
          color: Colors.black87,
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _baseOrderDeliveryChargeController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Base charge",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message:
                      "This will be the minimum charge per order deliveries",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _weightController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Weight",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Container(
                  padding: EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    "assets/icons/kg-measure-weight.svg",
                    height: 4.0,
                    width: 4.0,
                  ),
                ),
                suffixIcon: Tooltip(
                  message:
                      "Measured in grams. This will be used for dividing the total weight of an item",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _pricePerWeightController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Price per weight",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message: "Price per divided weight for an item / product",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _volumeController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Volume",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.indeterminate_check_box_outlined),
                suffixIcon: Tooltip(
                  message:
                      "Measured in cubic millimeter (mm3). This will be used for dividing the total volume of an item",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _pricePerVolumeController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Price per volume",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message: "Price per divided volume for an item / product",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
      ],
    );
  }

  Widget _deliveryDeliveryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: DEFAULT_SPACE_MARGIN, left: DEFAULT_SPACE_MARGIN),
          child: Text(
            "Delivery Delivery Charges",
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
          ),
        ),
        Divider(
          height: 8.0,
          color: Colors.black87,
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _baseDeliveryDeliveryChargeController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Base charge",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message:
                      "This will be the minimum charge per delivery deliveries",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _distanceController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Distance",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.navigation_rounded),
                ),
                suffixIcon: Tooltip(
                  message:
                      "Measured in Km. This will be used for dividing the total distance of an item",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _pricePerDistanceController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Price per distance",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message:
                      "Price per divided distance for an item from its source location to the destination location",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _bikeChargeController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Bike Charge",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message: "Base delivery charge using bike delivery",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _motorCycleChargeController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Motorcycle Charge",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message: "Base delivery charge using motorcycle delivery",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _sedanController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Sedan Charge",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message: "Base delivery charge using Sedan delivery",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _auvController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "AUV Charge",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message:
                      "Base delivery charge using AUV(e.g: Toyota Innova, Mitsubishi adventure) delivery",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _pickupController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Pickup Charge",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message: "Base delivery charge using pickup delivery",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _suvController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "SUV Charge",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message:
                      "Base delivery charge using SUV(e.g: Toyota Fortuner, Mitsubishi Montero) delivery",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
        Container(
          margin: DEFAULT_SPACING,
          child: TextFormField(
            controller: _truckController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Truck Charge",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.monetization_on_rounded),
                suffixIcon: Tooltip(
                  message: "Base delivery charge using truck delivery",
                  child: Icon(Icons.info_outline_rounded),
                )),
          ),
        ),
      ],
    );
  }
}

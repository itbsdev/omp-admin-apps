import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:http/http.dart' as http;

class DeliveryNetworkService {
  final deliveryBaseUrl = "$BASE_FIREBASE_FUNCTIONS_API_URL/delivery";

  Future<void> searchForRider({ @required String deliveryId, @required String vehicleType }) async {
    assert(deliveryId != null && deliveryId.isNotEmpty);
    assert(vehicleType != null && vehicleType.isNotEmpty);

    final http.Client client = http.Client();
    final riderSearchUrl = "$deliveryBaseUrl/rider/search";

    try {
      final response = await client.post(riderSearchUrl, headers: {
        "isDev": "${!kReleaseMode}",
      }, body: {
        "deliveryId": deliveryId,
        "vehicleType": vehicleType
      });
      print("rider search: ${response.toString()}");
    } catch(err) {
      print("rider search error: $err");
    }

    return Future.value();
  }
}

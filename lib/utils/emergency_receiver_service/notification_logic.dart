import 'dart:convert';
import 'package:e14_client/classes/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NotifyType { fullScreenIntent, pushNotification }

class EmergencyNotification {
  LocationObject watchPoint, fireLocation;
  double radius;
  NotifyType notifyType;
  EmergencyNotification(
      {required this.watchPoint,
      required this.fireLocation,
      required this.radius,
      required this.notifyType});
}

@pragma('vm:entry-point')
Future<EmergencyNotification?> shouldSendEmergencyNotification(
    LocationObject fireLocation) async {
  final prefs = await SharedPreferences.getInstance();
  List<dynamic> watchLocations =
      jsonDecode(prefs.getString("watchLocations") ?? "[]");

  for (var watch in watchLocations) {
    if (Geolocator.distanceBetween(fireLocation.latitude,
            fireLocation.longitude, watch["latitude"], watch["longitude"]) <=
        watch["warningRadius"]) {
      return EmergencyNotification(
          notifyType: NotifyType.fullScreenIntent,
          watchPoint: LocationObject(watch["latitude"], watch["longitude"]),
          fireLocation: fireLocation,
          radius: watch["warningRadius"].toDouble());
    }
  }

  return null;
}

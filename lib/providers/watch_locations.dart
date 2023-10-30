import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Watch location infos:
/// - latitude | double
/// - longitude | double
/// - warningRadius | double
/// These infos will be used for notify or warn user by their choice.
class WatchLocations extends ChangeNotifier {
  List<dynamic> watchList = [];

  WatchLocations() {
    initialize();
  }

  initialize() async {
    final prefs = await SharedPreferences.getInstance();

    watchList = jsonDecode(prefs.getString("watchLocations") ?? "[]");
    notifyListeners();
  }

  add(double latitude, longitude, warningRadius) async {
    watchList.add({
      "latitude": latitude,
      "longitude": longitude,
      "warningRadius": warningRadius
    });
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("watchLocations", jsonEncode(watchList));
  }

  removeAt(int index) async {
    watchList.removeAt(index);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("watchLocations", jsonEncode(watchList));
  }
}

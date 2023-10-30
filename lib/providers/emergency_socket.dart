import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/foundation.dart';

import '../classes/location.dart';

class EmergencySocket extends ChangeNotifier {
  String url;
  late Socket socket;
  bool connected = false, socketReady = false, sent = false;

  EmergencySocket(this.url);

  establishConnection(String token) {
    try {
      socket = io(
          url,
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setAuth({"type": "user", "token": token})
              .build());
      socket.on("/controller/endpointsReady",
          (_) => {connectionState(true), readySocketState(true)});
      socket.on("reconnect", (_) => connectionState(true));
      socket.on("disconnect", (_) => connectionState(false));

      socket.connect();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  sendReport(LocationObject fireLocation) {
    socket.emit("/userEndpoints/emit/emergencyReport", {
      "fireLocation": {
        "latitude": fireLocation.latitude,
        "longitude": fireLocation.longitude,
        "locationApproximate": fireLocation.locationApproximate
      }
    });
    sent = true;
    notifyListeners();
  }

  connectionState(bool state) {
    connected = state;
    notifyListeners();
  }

  readySocketState(bool state) {
    socketReady = state;
    notifyListeners();
  }
}

import 'dart:async';
import 'package:e14_client/classes/location.dart';
import 'package:socket_io_client/socket_io_client.dart';

class StreamSocket {
  final _socketResponse = StreamController<dynamic>();

  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class Emergency {
  final String url;
  late Socket socket;
  StreamSocket streamSocket = StreamSocket();
  late Completer<bool> socketReady;

  Emergency({required this.url});

  bool establishConnection(String token) {
    socketReady = Completer<bool>();
    try {
      socket = io(
          url,
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setAuth({"type": "user", "token": token})
              .build());
      socket.on(
          "/controller/endpointsReady", (_) => socketReady.complete(true));
      socket.on("reconnect", (data) => socketReady = Completer<bool>());
      socket.connect();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> reportEmergency(LocationObject fireLocation) async {
    await socketReady.future;
    socket.emit("/userEndpoints/emit/emergencyReport", {
      "fireLocation": {
        "latitude": fireLocation.latitude,
        "longitude": fireLocation.longitude,
        "locationApproximate": fireLocation.locationApproximate
      }
    });
    streamSocket.addResponse(["sent"]);
    return true;
  }
}

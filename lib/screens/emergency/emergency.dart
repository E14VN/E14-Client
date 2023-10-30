import 'dart:async';

import 'package:e14_client/classes/location.dart';
import 'package:e14_client/providers/credentials.dart';
import 'package:e14_client/utils/emergency_emitter_service/socket_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class EmergencyDashboard extends StatefulWidget {
  const EmergencyDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _EmergencyDashboardState();
}

class _EmergencyDashboardState extends State<EmergencyDashboard> {
  late StreamSubscription<Position> positionStream;
  Emergency ask = Emergency(url: "https://e14.neursdev.tk");

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ask.establishConnection(
          Provider.of<Credentials>(context, listen: false).info.token!);

      ask.streamSocket.addResponse("locating");

      Geolocator.getCurrentPosition().then((Position location) async {
        if (location.accuracy < 10) {
          ask.reportEmergency(LocationObject(
              location.latitude, location.longitude,
              locationApproximate: location.accuracy));
        } else {
          ask.streamSocket.addResponse(["locating", location.accuracy]);
          positionStream = Geolocator.getPositionStream(
                  locationSettings:
                      const LocationSettings(accuracy: LocationAccuracy.best))
              .listen((Position? location) {
            ask.streamSocket.addResponse(["locating", location?.accuracy]);
            if (location != null && location.accuracy < 10) {
              ask.reportEmergency(LocationObject(
                  location.latitude, location.longitude,
                  locationApproximate: location.accuracy));
              positionStream.cancel();
            }
          });
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    ask.socket.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: ask.streamSocket.getResponse,
            builder: (context, snapshot) => snapshot.data != null
                ? Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Stack(children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                            snapshot.data[0] == "sent"
                                                ? Icons.circle_outlined
                                                : Icons.emergency_outlined,
                                            size: 64)),
                                    Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            height: 72,
                                            width: 72,
                                            child: CircularProgressIndicator(
                                                value:
                                                    snapshot.data[0] == "sent"
                                                        ? 1
                                                        : null)))
                                  ])),
                              Text(
                                snapshot.data[0] == "locating"
                                    ? "Đang định vị..."
                                    : snapshot.data[0] == "sent"
                                        ? "Đã gửi thành công"
                                        : "Đang gửi...",
                                style: const TextStyle(fontSize: 32),
                              ),
                              Text(
                                  snapshot.data[0] == "locating"
                                      ? "Đang hiệu chỉnh vị trí để giảm độ sai\nHiện tại: ${snapshot.data[1].toStringAsPrecision(2)}m | Yêu cầu: < 10m..."
                                      : snapshot.data[0] == "sent"
                                          ? "Thông báo của bạn đã được gửi, có thể đơn vị chữa cháy sẽ liên lạc với bạn."
                                          : "Đang kết nối tới máy chủ E14...",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              snapshot.data[0] == "locating"
                                  ? ElevatedButton(
                                      onPressed: () {
                                        ask.streamSocket
                                            .addResponse("skippingGPS");
                                        positionStream.cancel();
                                        Geolocator.getCurrentPosition()
                                            .then((Position location) async {
                                          ask.reportEmergency(LocationObject(
                                              location.latitude,
                                              location.longitude,
                                              locationApproximate:
                                                  location.accuracy));
                                        });
                                      },
                                      child: const Text("Bỏ qua hiệu chỉnh"))
                                  : Container()
                            ])))
                : Container()));
  }
}

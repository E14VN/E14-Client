import 'dart:async';
import 'package:e14_client/providers/watch_locations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'tools.dart';

class Zoning extends StatelessWidget {
  Zoning({super.key});

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  final ValueNotifier<LatLng> currentLocation =
      ValueNotifier<LatLng>(const LatLng(16, 106));

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => WatchLocations(),
        builder: (context, _) => Consumer<WatchLocations>(
            builder: (context, watchLocations, _) => Column(children: [
                  Expanded(
                      child: Stack(children: [
                    GoogleMap(
                        circles: <Circle>{
                          for (var index = 0;
                              index < watchLocations.watchList.length;
                              index++)
                            Circle(
                                consumeTapEvents: true,
                                onTap: () => watchLocations.removeAt(index),
                                strokeWidth: 2,
                                fillColor: Colors.green.withOpacity(.3),
                                strokeColor: Colors.green,
                                circleId: CircleId(UniqueKey().toString()),
                                center: LatLng(
                                    watchLocations.watchList[index]["latitude"],
                                    watchLocations.watchList[index]
                                        ["longitude"]),
                                radius: watchLocations.watchList[index]
                                        ["warningRadius"]
                                    .toDouble())
                        },
                        onMapCreated: (controller) =>
                            mapController.complete(controller),
                        onCameraMove: (position) =>
                            currentLocation.value = position.target,
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        compassEnabled: false,
                        initialCameraPosition: const CameraPosition(
                            target: LatLng(16, 106), zoom: 5.4)),
                    const Align(
                        alignment: Alignment.center,
                        child: IgnorePointer(
                            child: Icon(Icons.add, color: Colors.black))),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Tools(
                            mapController: mapController,
                            watchLocations: watchLocations,
                            currentLocation: currentLocation)),
                  ])),
                ])));
  }
}

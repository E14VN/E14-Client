import 'package:e14_client/classes/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/watch_locations.dart';

class EmergencyShowMap extends StatefulWidget {
  final LocationObject fireCircle;
  const EmergencyShowMap({super.key, required this.fireCircle});

  @override
  State<StatefulWidget> createState() => _EmergencyShowMapState();
}

class _EmergencyShowMapState extends State<EmergencyShowMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("E14 - Thông báo")),
      body: ChangeNotifierProvider(
          create: (_) => WatchLocations(),
          builder: (context, _) => Consumer<WatchLocations>(
              builder: (context, watchLocations, _) => GoogleMap(
                      circles: <Circle>{
                        for (var index = 0;
                            index < watchLocations.watchList.length;
                            index++)
                          Circle(
                              strokeWidth: 2,
                              fillColor: Colors.green.withOpacity(.3),
                              strokeColor: Colors.green,
                              circleId: CircleId(UniqueKey().toString()),
                              center: LatLng(
                                  watchLocations.watchList[index]["latitude"],
                                  watchLocations.watchList[index]["longitude"]),
                              radius: watchLocations.watchList[index]
                                      ["warningRadius"]
                                  .toDouble()),
                        Circle(
                            strokeWidth: 2,
                            fillColor: Colors.red.withOpacity(.3),
                            strokeColor: Colors.red,
                            circleId: CircleId(UniqueKey().toString()),
                            center: LatLng(widget.fireCircle.latitude,
                                widget.fireCircle.longitude),
                            radius: widget.fireCircle.locationApproximate ?? 10)
                      },
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(widget.fireCircle.latitude,
                              widget.fireCircle.longitude),
                          zoom: 18.0)))),
    );
  }
}

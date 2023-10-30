import 'dart:async';
import 'package:e14_client/providers/watch_locations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tools extends StatelessWidget {
  final Completer<GoogleMapController> mapController;
  final WatchLocations watchLocations;
  final ValueNotifier<LatLng> currentLocation;
  Tools(
      {super.key,
      required this.watchLocations,
      required this.mapController,
      required this.currentLocation});

  final ValueNotifier<bool> addReview = ValueNotifier<bool>(false),
      viewSaved = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([addReview, viewSaved]),
        builder: (context, _) =>
            Column(mainAxisSize: MainAxisSize.min, children: [
              FAButtons(addReview: addReview, viewSaved: viewSaved),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: addReview.value || viewSaved.value ? 12 : 0,
                      right: 12,
                      left: 12),
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.ease,
                      height: viewSaved.value
                          ? 300
                          : addReview.value
                              ? 100
                              : 0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.background),
                      child: viewSaved.value
                          ? WatchLocationsDisplay(
                              watchLocations: watchLocations,
                              mapController: mapController,
                              viewSaved: viewSaved)
                          : addReview.value
                              ? AddRadiusAdjust(
                                  watchLocations: watchLocations,
                                  currentLocation: currentLocation)
                              : Container()))
            ]));
  }
}

class FAButtons extends StatelessWidget {
  final ValueNotifier<bool> addReview, viewSaved;
  const FAButtons(
      {super.key, required this.addReview, required this.viewSaved});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
          padding: const EdgeInsets.all(12),
          child: FloatingActionButton.extended(
              onPressed: () =>
                  {addReview.value = false, viewSaved.value = !viewSaved.value},
              label: const Text("Đã lưu"),
              icon: Icon(
                  viewSaved.value ? Icons.expand_less : Icons.expand_more))),
      const Spacer(),
      Padding(
          padding: const EdgeInsets.all(12),
          child: FloatingActionButton.extended(
              onPressed: () =>
                  {viewSaved.value = false, addReview.value = !addReview.value},
              label: const Text("Thêm"),
              icon: Icon(addReview.value ? Icons.close : Icons.add))),
    ]);
  }
}

class WatchLocationsDisplay extends StatelessWidget {
  final ValueNotifier<bool> viewSaved;
  final WatchLocations watchLocations;
  final Completer<GoogleMapController> mapController;
  const WatchLocationsDisplay(
      {super.key,
      required this.watchLocations,
      required this.mapController,
      required this.viewSaved});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: watchLocations.watchList.length,
        itemBuilder: (context, index) => InkWell(
            onTap: () async {
              viewSaved.value = false;
              (await mapController.future).animateCamera(
                  CameraUpdate.newLatLngZoom(
                      LatLng(watchLocations.watchList[index]["latitude"],
                          watchLocations.watchList[index]["longitude"]),
                      16.7));
            },
            child: ListTile(
              title: Text("Vị trí số $index"),
            )));
  }
}

class AddRadiusAdjust extends StatelessWidget {
  final WatchLocations watchLocations;
  final ValueNotifier<LatLng> currentLocation;
  AddRadiusAdjust(
      {super.key, required this.watchLocations, required this.currentLocation});

  final ValueNotifier<double> radiusValue = ValueNotifier<double>(200);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Bán kính khoanh vùng"),
        ValueListenableBuilder(
            valueListenable: radiusValue,
            builder: (context, _, __) =>
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Slider(
                      value: radiusValue.value,
                      min: 100,
                      max: 1000,
                      onChanged: (value) => {radiusValue.value = value}),
                  Text("${radiusValue.value.toInt()} m")
                ]))
      ]),
      ElevatedButton(
          onPressed: () => watchLocations.add(currentLocation.value.latitude,
              currentLocation.value.longitude, radiusValue.value),
          child: const Text("Lưu"))
    ]);
  }
}

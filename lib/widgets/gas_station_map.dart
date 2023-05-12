import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../util/location_util.dart';

class GasStationMap extends StatelessWidget {
  final List<Marker> markers;
  GasStationMap({Key? key, required this.markers}) : super(key: key);

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  late CameraPosition _startPoint;
  late Marker _startMarker;
  late LatLng _startLatLng;

  @override
  Widget build(BuildContext context) {
    markers.add(_startMarker);
    return FutureBuilder(
      future: getCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _startLatLng = LatLng(
              snapshot.data!.latitude, snapshot.data!.longitude);
          _startPoint = CameraPosition(
            target: _startLatLng,
            zoom: 7,
          );
          _startMarker = Marker(
              markerId: const MarkerId('Current location'),
              infoWindow: const InfoWindow(title: 'Current location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              position: _startLatLng);
          return GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _startPoint,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set.from(markers),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

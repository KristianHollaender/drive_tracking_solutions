import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GasStationMap extends StatelessWidget {
  final Set<Marker> markers;
  final GeoPoint geoPoint;

  GasStationMap({Key? key, required this.geoPoint, required this.markers})
      : super(key: key);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition _startPoint;
  late LatLng _startLatLng;

  @override
  Widget build(BuildContext context) {
    _startLatLng = LatLng(geoPoint.latitude, geoPoint.longitude);
    _startPoint = CameraPosition(
      target: _startLatLng,
      zoom: 12,
    );
    return GoogleMap(
      mapType: MapType.hybrid,
      compassEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      initialCameraPosition: _startPoint,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set.of(markers),
    );
  }
}

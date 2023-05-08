import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/tour.dart';

class TourMap extends StatelessWidget {
  final Tour tour;

  TourMap({super.key, required this.tour});

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  late CameraPosition _startPoint;
  late CameraPosition _endPoint;
  late Marker _startMarker;
  late Marker _endMarker;
  late LatLng _startLatLng;
  late LatLng _endLatLng;


  @override
  Widget build(BuildContext context) {
    _startLatLng = LatLng(
        tour.startPoint.latitude, tour.startPoint.longitude);
    _startPoint = CameraPosition(
      target: _startLatLng,
      zoom: 7,
    );
    _startMarker = Marker(
        markerId: const MarkerId('start'),
        infoWindow: const InfoWindow(title: 'Start point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: _startLatLng);
    _endLatLng =
        LatLng(tour.endPoint.latitude, tour.endPoint.longitude);
    _endPoint = CameraPosition(
      target: _endLatLng,
      zoom: 7,
    );
    _endMarker = Marker(
        markerId: const MarkerId('end'),
        infoWindow: const InfoWindow(title: 'End point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: _endLatLng);
    
    return Column(
      children: [
        Flexible(
          flex: 3,
          child: GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _startPoint,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {_startMarker, _endMarker},
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flexible(
            flex: 1,
            child: FloatingActionButton.extended(
              onPressed: _goToTheEndPoint,
              label: const Text('To the end point'),
              icon: const Icon(Icons.accessible_forward_outlined),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _goToTheEndPoint() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_endPoint));
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/tour.dart';

class TourMap extends StatefulWidget {
  final Tour tour;

  const TourMap({super.key, required this.tour});

  @override
  State<TourMap> createState() => TourMapState();
}

class TourMapState extends State<TourMap> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  late CameraPosition _startPoint;
  late CameraPosition _endPoint;
  late Marker _startMarker;
  late Marker _endMarker;
  late LatLng _startLatLng;
  late LatLng _endLatLng;

  @override
  void initState() {
    super.initState();
    _startLatLng = LatLng(
        widget.tour.startPoint.latitude, widget.tour.startPoint.longitude);
    _startPoint = CameraPosition(
      target: _startLatLng,
      zoom: 7,
    );
    _startMarker = Marker(
        markerId: const MarkerId('start'),
        infoWindow: const InfoWindow(title: 'Start point'),
        icon: BitmapDescriptor.defaultMarker,
        position: _startLatLng);
    _endLatLng =
        LatLng(widget.tour.endPoint.latitude, widget.tour.endPoint.longitude);
    _endPoint = CameraPosition(
      target: _endLatLng,
      zoom: 7,
    );
    _endMarker = Marker(
        markerId: const MarkerId('end'),
        infoWindow: const InfoWindow(title: 'End point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(23),
        position: _endLatLng);
  }

  @override
  Widget build(BuildContext context) {
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

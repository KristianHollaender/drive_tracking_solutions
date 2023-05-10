import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

CameraPosition? _initialCameraPosition;
CameraPosition? _currentLocationCameraPosition;
LatLng? _latLng;
Future<GeoPoint> getCurrentLocation() async {
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
  }

  _locationData = await location.getLocation();

  _latLng = LatLng(_locationData.latitude!, _locationData.longitude!);

  _initialCameraPosition = CameraPosition(
    target: _latLng!,
    zoom: 17.5,
  );

  _currentLocationCameraPosition = CameraPosition(
    target: _latLng!,
    zoom: 17.5,
  );

  return GeoPoint(_locationData.latitude!, _locationData.longitude!);
}
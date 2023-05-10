import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

Future<String> getAddressFromLatLong(GeoPoint start) async {
  List<Placemark> startPlacemarks = await placemarkFromCoordinates(
      start.latitude, start.longitude);

  Placemark startPlace = startPlacemarks[0];

  String startAddress = '${startPlace.name}, ${startPlace.country}';

  return startAddress;
}




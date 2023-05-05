import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

Future<String> getAddressFromLatLong(GeoPoint start, GeoPoint end) async {
  List<Placemark> startPlacemarks = await placemarkFromCoordinates(
      start.latitude, start.longitude);
  List<Placemark> endPlacemarks = await placemarkFromCoordinates(
      end.latitude, end.longitude);

  Placemark startPlace = startPlacemarks[0];
  Placemark endPlace = endPlacemarks[0];

  String startAddress = '${startPlace.name}, ${startPlace.country}';
  String endAddress = '${endPlace.name}, ${endPlace.country}';

  return 'From: $startAddress\nTo: $endAddress';
}

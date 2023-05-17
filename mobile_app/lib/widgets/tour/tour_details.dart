import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/widgets/tour/tour_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/check_point.dart';
import '../../models/tour.dart';
import 'card_details_widget.dart';

class TourDetails extends StatelessWidget {
  final Tour tour;
  final String id;

  TourDetails({Key? key, required this.tour, required this.id})
      : super(key: key);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tour Details"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '${tour.startTime?.day} ${tour.getMonth(tour.startTime!)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: FutureBuilder(
              future: fireService.getCheckPointFromTour(tour.tourId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  return TourMap(tour: tour, markers: addToMarkersList(snapshot.data));
                }else{
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
          CardDetailsWidget(
            tour: tour,
          ),
        ],
      ),
    );
  }
  Set<Marker> addToMarkersList(QuerySnapshot<Object?>? data) {
    for (int i = 0; i < data!.docs.length; i++) {
      CheckPoint checkPoint = CheckPoint.fromMap(data.docs[i].data() as Map<String, dynamic>);
      Marker marker = Marker(
        markerId: MarkerId('Marker $i'),
        position: LatLng(checkPoint.truckStop.latitude, checkPoint.truckStop.longitude),
        infoWindow: InfoWindow(title: 'Marker $i'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      );
      markers.add(marker);
    }
    return markers;
  }
}

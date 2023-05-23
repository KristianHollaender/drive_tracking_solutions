import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/gas_station_repo.dart';
import 'package:drive_tracking_solutions/widgets/gas_station_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../models/util/gas_station.dart';

class GasStationWidget extends StatelessWidget {
  final GeoPoint geoPoint;

  GasStationWidget({Key? key, required this.geoPoint}) : super(key: key);

  late String radius;

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final gasRepo = Provider.of<GasStationRepo>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nearby gas stations',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: gasRepo.getNearByGasStations(
            GeoPoint(geoPoint.latitude, geoPoint.longitude), '2000'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            final result =
                GasStation.fromJson(snapshot.data as Map<String, dynamic>);
            return Column(
              children: [
                Flexible(
                  flex: 1,
                  child: GasStationMap(
                      geoPoint: geoPoint, markers: addToMarkersList(result)),
                ),
                Flexible(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: result.results?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0x7784E784),
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Name: ${result.results?[index].name}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Location: ${result.results?[index].geometry!.location!.lat} , ${result.results?[index].geometry!.location!.lng}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  result.results![index].vicinity!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Set<Marker> addToMarkersList(GasStation result) {
    for (int i = 0; i < result.results!.length; i++) {
      Marker marker = Marker(
        markerId: MarkerId(result.results![i].name!),
        position: LatLng(result.results![i].geometry!.location!.lat!,
            result.results![i].geometry!.location!.lng!),
        infoWindow: InfoWindow(title: result.results![i].name!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      markers.add(marker);
    }
    return markers;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/gas_station_repo.dart';
import 'package:drive_tracking_solutions/widgets/gas_station_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../models/util/gas_station.dart';
import '../util/location_util.dart';

class GasStationWidget extends StatefulWidget {
  GasStationWidget({Key? key}) : super(key: key);

  @override
  State<GasStationWidget> createState() => _GasStationWidgetState();
}

class _GasStationWidgetState extends State<GasStationWidget> {
  late String radius;

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final gasRepo = Provider.of<GasStationRepo>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby gas stations'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: GasStationMap(markers: markers,),
          ),
          const Padding(padding: EdgeInsets.all(12)),
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: _getLocationBuilder(gasRepo),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<GeoPoint> _getLocationBuilder(GasStationRepo gasRepo) {
    return FutureBuilder(
      future: getCurrentLocation(),
      builder: (context, locationSnapshot) {
        if (locationSnapshot.hasData) {
          return _getNearByGasStationsWidget(gasRepo, locationSnapshot);
        } else if (locationSnapshot.hasError) {
          return Text(locationSnapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  FutureBuilder<dynamic> _getNearByGasStationsWidget(
      GasStationRepo gasRepo, AsyncSnapshot<GeoPoint> locationSnapshot) {
    return FutureBuilder(
      future: gasRepo.getNearByGasStations(
          GeoPoint(locationSnapshot.data!.latitude,
              locationSnapshot.data!.longitude),
          '2000'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          final result =
              GasStation.fromJson(snapshot.data as Map<String, dynamic>);
          return SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: result.results?.length,
              itemBuilder: (context, index) {
                addToMarkersList(result);
                return Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text("Name: ${result.results?[index].name}"),
                      Text(
                          "Location: ${result.results?[index].geometry!.location!.lat} , ${result.results?[index].geometry!.location!.lng}"),
                      Text(result.results![index].vicinity!),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  void addToMarkersList(GasStation result){
    for(int i = 0; i < result.results!.length; i++){
      Marker marker = Marker(
        markerId: MarkerId(result.results![i].name!),
        position: LatLng(result.results![i].geometry!.location!.lat!, result.results![i].geometry!.location!.lng!),
        infoWindow: InfoWindow(title: result.results![i].name!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      markers.add(marker);
    }

  }
}

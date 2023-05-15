import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/drive_tracking.dart';
import 'package:drive_tracking_solutions/util/calender_util.dart';
import 'package:drive_tracking_solutions/widgets/gas_stations_widget.dart';
import 'package:drive_tracking_solutions/widgets/timer_row.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  final Completer<GoogleMapController> mapsController =
  Completer<GoogleMapController>();
  LocationData? currentLocation;
  StreamSubscription<LocationData>? _sub;

  bool _tourStarted = false;


  void listenToCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
          (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await mapsController.future;
    _sub = location.onLocationChanged.listen(
          (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 17.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
      },
    );
  }

  void stopListeningToLocation() async {
    _sub!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final tracker = Provider.of<DriveTracker>(context);

    return FutureBuilder(
      future: tracker.getCurrentLocation(),
      builder: (context, snapshot) {
        if (tracker.latLng == null || tracker.initialCameraPosition == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Home"),
          ),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.hybrid,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        compassEnabled: true,
                        markers: Set<Marker>.of(tracker.marker),
                        initialCameraPosition: tracker.initialCameraPosition!,
                        onMapCreated: (GoogleMapController controller) {
                          mapsController.complete(controller);
                        },
                      ),
                      Positioned(
                        bottom: 16.0,
                        right: 165.0,
                        left: 165.0,
                        child: FloatingActionButton.extended(
                          heroTag: "followBtn",
                          backgroundColor: const Color(0xb3d9dcd9),
                          onPressed: () {
                            setState(() {
                              tracker.click = !tracker.click;
                            });
                            if (tracker.click) {
                              listenToCurrentLocation();
                            } else {
                              stopListeningToLocation();
                            }
                          },
                          label: tracker.click
                              ? const Icon(Icons.navigation)
                              : const Icon(Icons.navigation_outlined),
                        ),
                      ),
                      Positioned(
                        bottom: 245.0,
                        right: 285.0,
                        left: 15.0,
                        child: FloatingActionButton.extended(
                          backgroundColor: const Color(0xb3d9dcd9),
                          onPressed: () async {
                            GeoPoint currentLocation =
                            await tracker.getCurrentLocation();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GasStationWidget(
                                    geoPoint: currentLocation)));
                          },
                          label: const Text('Gas Stations'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                height: 45.0,
                                child: FloatingActionButton.extended(
                                  heroTag: "startTourBtn",
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  onPressed: (){
                                    tracker.startTour();
                                    _tourStarted = true;
                                  },
                                  label: const Text("Start tour"),
                                  backgroundColor: Color(0xff26752b)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10.0, left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                height: 45.0,
                                child: FloatingActionButton.extended(
                                  heroTag: "startRestingBtn",
                                  icon: const Icon(Icons.restaurant),
                                  onPressed: () {
                                    if (!tracker.isResting) {
                                      tracker.startResting();
                                    } else {
                                      tracker.stopResting();
                                    }
                                  },
                                  label: StreamBuilder<void>(
                                    stream: tracker.tickerStream,
                                    builder: (context, snapshot) {
                                      return Text(tracker.isResting
                                          ? "End resting"
                                          : "Start rest");
                                    },
                                  ),
                                  backgroundColor: Color(0xff26752b),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                height: 45.0,
                                child: FloatingActionButton.extended(
                                  heroTag: "checkpointBtn",
                                  icon: const Icon(Icons.add_location_alt),
                                  onPressed: () async {
                                    //_setCheckpointLocation();
                                    GeoPoint currentLocation =
                                    await tracker.getCurrentLocation();
                                    fireService.addCheckpoint(
                                        fireService.tourId!, currentLocation);
                                  },
                                  label: const Text("Checkpoint"),
                                  backgroundColor: Color(0xff26752b),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                height: 45.0,
                                child: FloatingActionButton.extended(
                                  heroTag: "endTourBtn",
                                  icon: const Icon(Icons.close_sharp),
                                  onPressed: () async {
                                    //_setEndLocation();
                                    tracker.endTour();
                                    _tourStarted = false;
                                  },
                                  label: const Text("End tour"),
                                  backgroundColor: Color(0xff26752b),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          children: const [TimerRow()],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
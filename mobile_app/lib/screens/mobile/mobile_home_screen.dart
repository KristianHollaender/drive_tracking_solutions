import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/drive_tracking.dart';
import 'package:drive_tracking_solutions/util/calender_util.dart';
import 'package:drive_tracking_solutions/widgets/gas_stations_widget.dart';
import 'package:drive_tracking_solutions/widgets/timer_row.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
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
                          tracker.mapsController.complete(controller);
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
                              tracker.listenToCurrentLocation();
                            } else {
                              tracker.stopListeningToLocation();
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
                                  onPressed: !tracker.tourStarted
                                      ? () {
                                    setState(() {
                                      tracker.tourStarted = true;
                                    });
                                    tracker.startTour();
                                  }
                                      : null,
                                  label: const Text("Start tour"),
                                  backgroundColor: tracker.tourStarted
                                      ? const Color(0xb3d9dcd9)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: tracker.tourStarted,
                      child: Padding(
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
                                      setState(() {
                                        tracker.tourStarted = false;
                                      });
                                    },
                                    label: const Text("End tour"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
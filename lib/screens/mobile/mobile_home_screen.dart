import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/geo_point.dart';
import 'package:drive_tracking_solutions/logic/drive_tracking.dart';
import 'package:drive_tracking_solutions/util/calender_util.dart';
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
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition? _initialCameraPosition;
  CameraPosition? _currentLocationCameraPosition;
  LatLng? _latLng;
  StreamSubscription<LocationData>? sub;

  List<Marker> _marker = [];

  bool _click = false;


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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startTime = DateTime.now();
    DateTime endTime = DateTime.now();

    final tracker = Provider.of<DriveTracker>(context);

    return FutureBuilder(
      future: getCurrentLocation(),
      builder: (context, snapshot) {
        if (_latLng == null || _initialCameraPosition == null) {
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
                        markers: Set<Marker>.of(_marker),
                        initialCameraPosition: _initialCameraPosition!,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                      Positioned(
                        bottom: 16.0,
                        right: 165.0,
                        left: 165.0,
                        child: FloatingActionButton.extended(
                          backgroundColor: const Color(0xb3d9dcd9),
                          onPressed: () {
                            setState(() {
                              _click = !_click;
                            });
                            if (_click) {
                              _listenToCurrentLocation();
                            } else {
                              _stopListeningToLocation();
                            }
                          },
                          label: _click
                              ? const Icon(Icons.navigation)
                              : const Icon(Icons.navigation_outlined),
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
                              padding: EdgeInsets.all(4.0),
                              child: SizedBox(
                                height: 45.0,
                                child: FloatingActionButton.extended(
                                  icon: Icon(Icons.play_arrow_rounded),
                                  onPressed: !tracker.tourStarted
                                      ? () => startTour(startTime, tracker)
                                      : null,
                                  label: Text("Start tour"),
                                  backgroundColor: tracker.tourStarted
                                      ? Color(0xb3d9dcd9)
                                      : null, // set the background color based on _tourStarted
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
                        padding: EdgeInsets.only(
                            bottom: 10.0, left: 8.0, right: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 45.0,
                                  child: FloatingActionButton.extended(
                                    icon: Icon(Icons.restaurant),
                                    onPressed: () {
                                      _toggleResting();
                                    },
                                    label: Text
                                      (tracker.isResting
                                        ? "End resting"
                                        : "Start rest"),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 45.0,
                                  child: FloatingActionButton.extended(
                                    icon: Icon(Icons.add_location_alt),
                                    onPressed: () async {
                                      //_setCheckpointLocation();
                                      GeoPoint currentLocation =
                                          await getCurrentLocation();
                                      fireService.addCheckpoint(
                                          fireService.tourId!, currentLocation);
                                    },
                                    label: Text("Checkpoint"),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 45.0,
                                  child: FloatingActionButton.extended(
                                      icon: Icon(Icons.close_sharp),
                                      onPressed: () async {
                                        //_setEndLocation();
                                        await endTour(endTime, startTime, tracker);
                                      },
                                      label: Text(" End tour")),
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
                          children: [
                            TimerRow()
                          ],
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

  void _toggleResting() {
    final tracker = Provider.of<DriveTracker>(context, listen: false);
    if (!tracker.isResting) {
      tracker.startResting();
      fireService.startPause(fireService.tourId!, DateTime.now());
    } else {
      tracker.stopResting();
      print("pause ID:${fireService.pauseId}");
      fireService.stopPause(
          fireService.tourId, fireService.pauseId, DateTime.now());
    }
  }

  Future<void> startTour(DateTime startTime, DriveTracker tracker) async {
    tracker.startTour();
    GeoPoint currentLocation = await getCurrentLocation();
    await fireService.startTour(currentLocation, startTime);
    print(fireService.tourId);
    setState(() {
      tracker.tourStarted = true;
    });
    //_setStartLocation();
  }

  Future<void> endTour(DateTime endTime, DateTime startTime, DriveTracker tracker) async {
    tracker.endTour();
    GeoPoint currentLocation =
        await getCurrentLocation();
    endTime = DateTime.now();
    final duration =
        endTime.difference(startTime);
    final formattedDuration = Duration(
      hours: duration.inHours,
      minutes:
          duration.inMinutes.remainder(60),
      seconds:
          duration.inSeconds.remainder(60),
    );
    final totalTime = formattedDuration
        .toString()
        .split('.')
        .first;
    if (tracker.isResting) {
      await fireService.stopPause(
          fireService.tourId!,
          fireService.pauseId!,
          endTime);
    }
    await fireService.endTour(
        fireService.tourId!,
        currentLocation,
        endTime,
        totalTime);
  }



  Future<void> _setStartLocation() async {
    final GoogleMapController controller = await _controller.future;
    getCurrentLocation();
    final Marker _startLocationMarker = Marker(
        markerId: MarkerId("startLocation"),
        infoWindow: InfoWindow(title: "Route start"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: _latLng!);
    _marker.add(_startLocationMarker);
  }

  Future<void> _setCheckpointLocation() async {
    final GoogleMapController controller = await _controller.future;
    getCurrentLocation();
    final Marker _checkpointLocationMarker = Marker(
        markerId: MarkerId("checkpointLocation"),
        infoWindow: InfoWindow(title: "Checkpoint"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        position: _latLng!);
    _marker.add(_checkpointLocationMarker);
  }

  Future<void> _setEndLocation() async {
    final GoogleMapController controller = await _controller.future;
    getCurrentLocation();
    final Marker _endLocationMarker = Marker(
        markerId: MarkerId("startLocation"),
        infoWindow: InfoWindow(title: "Route end"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: _latLng!);
    _marker.add(_endLocationMarker);
  }

  LocationData? currentLocation;

  void _listenToCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    sub = location.onLocationChanged.listen(
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
        setState(() {});
      },
    );
  }

  void _stopListeningToLocation() async {
    sub!.cancel();
  }
}

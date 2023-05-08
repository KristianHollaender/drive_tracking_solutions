import 'dart:async';

import 'package:drive_tracking_solutions/widgets/timer_row.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}


class HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final GlobalKey<TimerRowState> CDLKey = GlobalKey();
  final GlobalKey<TimerRowState> DDLKey = GlobalKey();
  final GlobalKey<TimerRowState> DBTKey = GlobalKey();

  CameraPosition? _initialCameraPosition;
  CameraPosition? _currentLocationCameraPosition;
  LatLng? _latLng;
  StreamSubscription<LocationData>? sub;


  List<Marker> _marker = [];

  bool _click = false;

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
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
  }

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
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
              ),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 120.0,
                            height: 50.0,
                            child: FloatingActionButton.extended(
                                onPressed: (){
                                  CDLKey.currentState!.startTimer();
                                  DDLKey.currentState!.startTimer();
                                },
                                label: Text("Start tour")),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 120.0,
                            height: 50.0,
                            child: FloatingActionButton.extended(
                                onPressed: (){
                                  CDLKey.currentState!.stopTimer();
                                  DDLKey.currentState!.stopTimer();
                                  DBTKey.currentState!.startTimer();
                                }, label: Text("Checkpoint")),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 120.0,
                            height: 50.0,
                            child: FloatingActionButton.extended(
                                onPressed: null, label: Text("End tour")),
                          ),
                        )
                      ],
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TimerRow(key: CDLKey, title: "Continuous driving limit", duration: Duration(hours: 4, minutes: 30)),
                            TimerRow(key: DDLKey, title: "Daily driving limit", duration: Duration(hours: 9, minutes: 00)),
                            TimerRow(key: DBTKey, title: "Daily break time", duration: Duration(hours: 00, minutes: 45)),
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

  Future<void> _setStartLocation() async {
    getCurrentLocation();
    final Marker _startLocationMarker = Marker(
        markerId: MarkerId("startLocation"),
        infoWindow: InfoWindow(title: "Route start"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: _latLng!);
    _marker.add(_startLocationMarker);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_currentLocationCameraPosition!));
  }

  Future<void> _setEndLocation() async {
    getCurrentLocation();
    final Marker _endLocationMarker = Marker(
        markerId: MarkerId("startLocation"),
        infoWindow: InfoWindow(title: "Route end"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: _latLng!);
    _marker.add(_endLocationMarker);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_currentLocationCameraPosition!));
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

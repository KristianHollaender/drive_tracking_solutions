import 'dart:async';
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

  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  int _restingSeconds = 0;
  int _restingMinutes = 0;
  int _restingHours = 0;
  bool _isRunning = false;
  bool _isRestingRunning = false;



  Timer? _timer;
  Timer? _restingTimer;
  CameraPosition? _initialCameraPosition;
  CameraPosition? _currentLocationCameraPosition;
  LatLng? _latLng;
  StreamSubscription<LocationData>? sub;

  List<Marker> _marker = [];

  bool _click = false;
  bool _StopWatchClick = true;



  Future<void> getCurrentLocation() async {
    Location location = new Location();

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
    _stopTimer();
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 95.0,
                              height: 45.0,
                              child: FloatingActionButton.extended(
                                  onPressed:
                                  _setStartLocation, label: Text("Start tour")),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 95.0,
                              height: 95.0,
                              child: FloatingActionButton.extended(
                                onPressed: () {
                                  setState(() {
                                    _StopWatchClick = !_StopWatchClick;
                                  });
                                  if (_StopWatchClick && !_isRunning ) {
                                    _isRunning = true;
                                    _isRestingRunning = false;
                                    _stopTimer();
                                    _startRestingTimer();
                                  } else if(!_isRestingRunning){
                                    _isRunning = false;
                                    _isRestingRunning = true;
                                    _startTimer();
                                    _stopRestingTimer();
                                  }
                                },
                                label: _StopWatchClick
                                    ? const Icon(
                                        Icons.play_arrow_outlined,
                                        size: 80.0,
                                      )
                                    : const Icon(
                                        Icons.pause_outlined,
                                        size: 80.0,
                                      ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "Current time",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Container(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        _getTime(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 135.0),
                            child: SizedBox(
                              child: Center(
                                child: Text(
                                  "Current resting time: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SizedBox(
                              child: Center(
                                child: Text(
                                  _getRestingTime(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 95.0,
                              height: 95.0,
                              child: FloatingActionButton(
                                onPressed: () {
                                  _completeTimerReset();
                                },
                                child: Icon(Icons.close_outlined, size: 80.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
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
        position: _latLng!
    );
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
        position: _latLng!
    );
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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        if (_seconds == 60) {
          _seconds = 0;
          _minutes++;
        }
        if (_minutes == 60) {
          _minutes = 0;
          _hours++;
        }
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }


  String _getTime() {
    return "${_hours.toString().padLeft(2, '0')} : ${_minutes.toString().padLeft(2, '0')} : ${_seconds.toString().padLeft(2, '0')}";
  }

  void _startRestingTimer() {
    _restingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _restingSeconds++;
        if (_restingSeconds == 60) {
          _restingSeconds = 0;
          _restingMinutes++;
        }
        if (_restingMinutes == 60) {
          _restingMinutes = 0;
          _restingHours++;
        }
      });
    });
  }

  void _stopRestingTimer() {
    if (_restingTimer != null) {
      _restingTimer!.cancel();
      _restingTimer = null;
    }
  }


  String _getRestingTime() {
    return "${_restingHours.toString().padLeft(2, '0')} : ${_restingMinutes.toString().padLeft(2, '0')} : ${_restingSeconds.toString().padLeft(2, '0')}";
  }

  void _resetTimer() {
    setState(() {
      _seconds = 0;
      _minutes = 0;
      _hours = 0;
    });
  }

  void _resetRestingTimer() {
    setState(() {
      _restingSeconds = 0;
      _restingMinutes = 0;
      _restingHours = 0;
    });
  }

  void _completeTimerReset(){
    _resetTimer();
    _resetRestingTimer();
    _stopTimer();
    _stopRestingTimer();
    _setEndLocation();
    _StopWatchClick = true;
  }

}

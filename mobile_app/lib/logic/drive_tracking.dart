import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/tour_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../util/calender_util.dart';

class DriveTracker {
  final Stopwatch _continuousDrivingLimitTimer = Stopwatch();
  final Stopwatch _dailyDrivingLimitTimer = Stopwatch();
  final Stopwatch _dailyBreakTimeTimer = Stopwatch();

  final Duration _continuousDrivingDuration =
      const Duration(hours: 4, minutes: 30);
  final Duration _dailyDrivingDuration = const Duration(hours: 9);
  final Duration _dailyBreakDuration = const Duration(minutes: 45);

  bool isResting = false;
  bool tourStarted = false;

  late DateTime _startTime;
  late DateTime _endTime;

  Timer? _timer;
  final _ticker = StreamController<int>();
  late final Stream<int> tickerStream;
  CameraPosition? initialCameraPosition;
  CameraPosition? currentLocationCameraPosition;
  LatLng? latLng;
  late int checkpointNumber;
  final tourRepo = TourRepository();

  final Set<Marker> marker = {};

  bool click = false;

  DriveTracker() {
    tickerStream = _ticker.stream.asBroadcastStream();
    checkpointNumber = 0;
  }

  Future<void> startTour() async {
    marker.clear();
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (i) {
      _ticker.sink.add(i.tick);
    });
    _continuousDrivingLimitTimer.start();
    _dailyDrivingLimitTimer.start();
    GeoPoint currentLocation = await getCurrentLocation();
    await fireService.startTour(currentLocation, _startTime);
    setMarker(
        currentLocation,
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        const MarkerId("startPoint"),
        const InfoWindow(title: "Start point"));
    print(fireService.tourId);
  }

  Future<void> setCheckpoint() async {
    GeoPoint currentLocation = await getCurrentLocation();
    fireService.addCheckpoint(fireService.tourId!, currentLocation);

    checkpointNumber++; // Increment the checkpoint number for the next checkpoint
    String markerId = "Checkpoint $checkpointNumber"; // Construct the marker ID
    String title = "Checkpoint $checkpointNumber"; // Construct the title for infoWindow

    setMarker(
        currentLocation,
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        MarkerId(markerId), // Use the constructed marker ID
        InfoWindow(title: title)
    );
  }


  Future<void> endTour() async {
    checkpointNumber = 0;
    _timer?.cancel();
    _timer = null;
    isResting = false;
    _continuousDrivingLimitTimer.stop();
    _dailyDrivingLimitTimer.stop();
    _dailyBreakTimeTimer.stop();
    _continuousDrivingLimitTimer.reset();
    _dailyDrivingLimitTimer.reset();
    _dailyBreakTimeTimer.reset();
    GeoPoint currentLocation = await getCurrentLocation();
    _endTime = DateTime.now();
    final duration = _endTime.difference(_startTime);
    final formattedDuration = Duration(
      hours: duration.inHours,
      minutes: duration.inMinutes.remainder(60),
      seconds: duration.inSeconds.remainder(60),
    );
    final totalTime = formattedDuration.toString().split('.').first;
    if (isResting) {
      await fireService.stopPause(
          fireService.tourId!, fireService.pauseId!, _endTime);
    }
    await fireService.endTour(
        fireService.tourId!, currentLocation, _endTime, totalTime);



    setMarker(
        currentLocation,
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        const MarkerId("endPoint"),
        const InfoWindow(title: "End point"));

    _timer = Timer.periodic(const Duration(seconds: 1), (i) {
      _ticker.sink.add(i.tick);
    });

    // Uses cloud functions to calculate the total tour time
    await tourRepo.getTotalTourTime(fireService.tourId!);

    // Uses cloud functions to calculate the total pause time on tour
    await tourRepo.getTotalPauseTimeOnTour(fireService.tourId!);

  }

  Duration getContinuousDrivingLimit() {
    return _continuousDrivingDuration - _continuousDrivingLimitTimer.elapsed;
  }

  Duration getDailyDrivingLimit() {
    return _dailyDrivingDuration - _dailyDrivingLimitTimer.elapsed;
  }

  Future<void> startResting() async{
    isResting = true;
    _continuousDrivingLimitTimer.stop();
    _dailyDrivingLimitTimer.stop();
    _dailyBreakTimeTimer.start();
    await fireService.startPause(fireService.tourId, DateTime.now());
  }

  Future<void> stopResting() async{
    isResting = false;
    _dailyBreakTimeTimer.stop();
    _continuousDrivingLimitTimer.start();
    _dailyDrivingLimitTimer.start();
    await fireService.stopPause(
        fireService.tourId, fireService.pauseId, DateTime.now());

    // Uses cloud functions to calculate the total pause on pause
    await tourRepo.getTotalPauseTimeOnPause(fireService.tourId!, fireService.pauseId!);

    // Uses cloud functions to calculate the total pause time on tour
    await tourRepo.getTotalPauseTimeOnTour(fireService.tourId!);
  }

  Duration getRestingTime() {
    return _dailyBreakDuration - _dailyBreakTimeTimer.elapsed;
  }

  Future<GeoPoint> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    locationData = await location.getLocation();

    latLng = LatLng(locationData.latitude!, locationData.longitude!);

    initialCameraPosition = CameraPosition(
      target: latLng!,
      zoom: 17.5,
    );

    currentLocationCameraPosition = CameraPosition(
      target: latLng!,
      zoom: 17.5,
    );

    return GeoPoint(locationData.latitude!, locationData.longitude!);
  }

  double calculateCDLProgress() {
    final Duration elapsedTime = getContinuousDrivingLimit();
    final double progress = 1 -
        (elapsedTime.inMilliseconds /
            _continuousDrivingDuration.inMilliseconds);
    return progress.clamp(0.0, 1.0);
  }

  double calculateDDLProgress() {
    final Duration elapsedTime = getDailyDrivingLimit();
    final double progress =
        1 - (elapsedTime.inMilliseconds / _dailyDrivingDuration.inMilliseconds);
    return progress.clamp(0.0, 1.0);
  }

  double calculateRestingProgress() {
    final Duration elapsedTime = getRestingTime();
    final double progress =
        1 - (elapsedTime.inMilliseconds / _dailyBreakDuration.inMilliseconds);
    return progress.clamp(0.0, 1.0);
  }

  void setMarker(GeoPoint currentLocation, BitmapDescriptor bitmapDescriptor,
      MarkerId markerId, InfoWindow infoWindow) async {
    final Marker checkpointLocationMarker = Marker(
        markerId: markerId,
        infoWindow: infoWindow,
        icon: bitmapDescriptor,
        position: LatLng(currentLocation.latitude, currentLocation.longitude));
    marker.add(checkpointLocationMarker);
    print(marker.length);
  }
}

extension DurationExtension on Duration {
  String durationToString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return "${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

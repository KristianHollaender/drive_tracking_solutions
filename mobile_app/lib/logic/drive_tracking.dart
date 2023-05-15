import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../util/calender_util.dart';

class DriveTracker {
  Stopwatch _continuousDrivingLimitTimer = Stopwatch();
  Stopwatch _dailyDrivingLimitTimer = Stopwatch();
  Stopwatch _dailyBreakTimeTimer = Stopwatch();

  Duration _continuousDrivingDuration = const Duration(hours: 4, minutes: 30);
  Duration _dailyDrivingDuration = const Duration(hours: 9);
  Duration _dailyBreakDuration = const Duration(minutes: 45);

  bool isResting = false;
  bool tourStarted = false;

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();

  Timer? _timer;
  final _ticker = StreamController<int>();
  late final Stream<int> tickerStream;
  CameraPosition? initialCameraPosition;
  CameraPosition? currentLocationCameraPosition;
  LatLng? latLng;


  final Set<Marker> marker = {};

  bool click = false;

  DriveTracker() {
    tickerStream = _ticker.stream.asBroadcastStream();
  }

  Future<void> startTour() async {
    tourStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (i) {
      _ticker.sink.add(i.tick);
    });
    _continuousDrivingLimitTimer.start();
    _dailyDrivingLimitTimer.start();
    GeoPoint currentLocation = await getCurrentLocation();
    await fireService.startTour(currentLocation, _startTime);
    print(fireService.tourId);
  }

  Future<void> endTour() async {
    _timer?.cancel();
    _timer = null;
    isResting = false;
    tourStarted = false;
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
  }

  Duration getCdl() {
    return _continuousDrivingDuration - _continuousDrivingLimitTimer.elapsed;
  }

  Duration getDdl() {
    return _dailyDrivingDuration - _dailyDrivingLimitTimer.elapsed;
  }


  void startResting() {
    isResting = true;
    _continuousDrivingLimitTimer.stop();
    _dailyDrivingLimitTimer.stop();
    _dailyBreakTimeTimer.start();
    fireService.startPause(fireService.tourId, DateTime.now());
  }

  void stopResting() {
    isResting = false;
    _dailyBreakTimeTimer.stop();
    _continuousDrivingLimitTimer.start();
    _dailyDrivingLimitTimer.start();
    fireService.stopPause(
        fireService.tourId, fireService.pauseId, DateTime.now());
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


  double calculateCdlProgress() {
    final Duration elapsedTime = getCdl();
    final double progress = 1 - (elapsedTime.inMilliseconds / _continuousDrivingDuration.inMilliseconds);
    return progress.clamp(0.0, 1.0);
  }

  double calculateDdlProgress() {
    final Duration elapsedTime = getDdl();
    final double progress = 1 - (elapsedTime.inMilliseconds / _dailyDrivingDuration.inMilliseconds);
    return progress.clamp(0.0, 1.0);
  }

  double calculateRestingProgress() {
    final Duration elapsedTime = getRestingTime();
    final double progress = 1 - (elapsedTime.inMilliseconds / _dailyBreakDuration.inMilliseconds);
    return progress.clamp(0.0, 1.0);
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

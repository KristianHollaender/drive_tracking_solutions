import 'dart:async';

class DriveTracker {
  Stopwatch cdl = Stopwatch();
  Stopwatch ddl = Stopwatch();
  Stopwatch dbt = Stopwatch();

  Duration cdlDuration = const Duration(hours: 4, minutes: 30);
  Duration ddlDuration = const Duration(hours: 9);
  Duration dbtDuration = const Duration(minutes: 45);

  bool tourStarted = false;
  bool isResting = false;

  Timer? timer;
  final _ticker = StreamController<int>();
  late final Stream<int> tickerStream;
  
  DriveTracker() {
    tickerStream = _ticker.stream.asBroadcastStream();
  }

  void startTour(){
    timer = Timer.periodic(const Duration(seconds: 1), (i) {
      _ticker.sink.add(i.tick);
    });
    cdl.start();
    ddl.start();
  }

  void stopTour(){
    cdl.stop();
    ddl.stop();
  }

  void endTour(){
    timer?.cancel();
    timer = null;
    tourStarted = false;
    isResting = false;
    cdl.stop();
    ddl.stop();
    dbt.stop();
    cdl.reset();
    ddl.reset();
    dbt.reset();
  }


  Duration getCdl() {
    return cdlDuration - cdl.elapsed;
  }

  Duration getDdl() {
    return ddlDuration - ddl.elapsed;
  }

  void startResting(){
    isResting = true;
    cdl.stop();
    ddl.stop();
    dbt.start();
  }

  void stopResting(){
    dbt.stop();
    cdl.start();
    ddl.start();
  }

  Duration getRestingTime() {
    return dbtDuration - dbt.elapsed;
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
import 'dart:async';

class DriveTracker {
  Stopwatch cdl = Stopwatch();
  Stopwatch ddl = Stopwatch();
  Stopwatch dbt = Stopwatch();

  Duration cdlDuration = Duration(hours: 4, minutes: 30);
  Duration ddlDuration = Duration(hours: 9);
  Duration dbtDuration = Duration(minutes: 45);

  bool tourStarted = false;
  bool isResting = false;

  Timer? timer;
  final _ticker = StreamController<int>();
  late final Stream<int> tickerStream;
  
  DriveTracker() {
    tickerStream = _ticker.stream.asBroadcastStream();
  }

  void startTour(){
    timer = Timer.periodic(Duration(seconds: 1), (i) {
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
    String twoDigitMinutes = twoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(this.inSeconds.remainder(60));
    return "${twoDigits(this.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
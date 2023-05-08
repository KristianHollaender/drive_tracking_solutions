import 'package:flutter/material.dart';

class TimerRow extends StatefulWidget {
  final String title;
  final Duration duration;

  TimerRow({super.key, required this.title, required this.duration});

  @override
  TimerRowState createState() => TimerRowState();
}

class TimerRowState extends State<TimerRow> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Duration _duration;
  late String _remainingTime;
  late bool _isRunning;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _duration = widget.duration;
    _remainingTime = _durationToString(_duration);
    _isRunning = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void startTimer() {
    if (!_isRunning) {
      _controller = AnimationController(
        vsync: this,
        duration: _duration,
      )..reverse(from: 1.0);

      _controller.addListener(() {
        setState(() {
          _remainingTime = _durationToString(
              (_duration * _controller.value));
        });
      });

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Timer completed
        }
      });

      _isRunning = true;
      _controller.reverse();

      //TODO FIKS DURATION SÅ DEN IKKE GENSTARTER HVER GANG
      print(_duration);
      print(widget.duration);
    }
  }

  void stopTimer() {
    if (_isRunning) {
      _isRunning = false;
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xff000000)),
                borderRadius: BorderRadius.circular(8.0),
                color: Color(0xff427e48)),
            width: 390.0,
            height: 65.0,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _remainingTime,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return LinearProgressIndicator(
                        value: _controller.value,
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
    _duration = widget.duration;
    _remainingTime = _durationToString(_duration);
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    )..reverse(from: 1.0);
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

  void startCountdown() {
    if (!_isRunning) {
      _isRunning = true;
      _controller.reverse(
          from: _controller.value == 0.0 ? 1.0 : _controller.value);
      _controller.addListener(() {
        setState(() {
          _remainingTime = _durationToString((_duration * _controller.value));
        });
      });

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Timer completed
        }
      });
    }
  }

  void stopCountdown() {
    if (_isRunning) {
      _isRunning = false;
      _controller.stop();
    }
  }

  void clearTimer() {
    _isRunning = false;
    _controller.reset();
    _duration = widget.duration;
    _remainingTime = _durationToString(_duration);
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    )..reverse(from: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xff000000)),
                borderRadius: BorderRadius.circular(8.0),
                color: Color(0xff427e48)),
            width: MediaQuery.of(context).size.width * 0.95,
            height: 65.0,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
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
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: LinearProgressIndicator(
                          value: _controller.value,
                        ),
                      ),
                    ],
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

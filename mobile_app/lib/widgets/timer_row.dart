import 'package:drive_tracking_solutions/logic/drive_tracking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerRow extends StatefulWidget {
  const TimerRow({super.key});

  @override
  TimerRowState createState() => TimerRowState();
}

class TimerRowState extends State<TimerRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final tracker = Provider.of<DriveTracker>(context);
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff000000)),
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xff427e48)),
                width: MediaQuery.of(context).size.width * 0.95,
                height: 65.0,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: StreamBuilder<int>(
                            stream: tracker.tickerStream,
                            builder: (context, snapshot) {
                              return Text(
                                tracker.getCdl().durationToString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Continous driving limit",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: LinearProgressIndicator(
                              value: tracker.calculateCdlProgress(),
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
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff000000)),
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xff427e48)),
                width: MediaQuery.of(context).size.width * 0.95,
                height: 65.0,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: StreamBuilder<Object>(
                            stream: tracker.tickerStream,
                            builder: (context, snapshot) {
                              return Text(
                                tracker.getDdl().durationToString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily driving limit",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: LinearProgressIndicator(
                              value: tracker.calculateDdlProgress(),
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
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff000000)),
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xff427e48)),
                width: MediaQuery.of(context).size.width * 0.95,
                height: 65.0,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: StreamBuilder<void>(
                            stream: tracker.tickerStream,
                            builder: (context, snapshot) {
                              return Text(
                                tracker.getRestingTime().durationToString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily break time",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: LinearProgressIndicator(
                              value: tracker.calculateRestingProgress(),
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
        ),
      ],
    );
  }
}
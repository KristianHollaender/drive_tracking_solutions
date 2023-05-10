import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/fire_service.dart';
import 'package:drive_tracking_solutions/models/checkPoint.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pause.dart';
import '../../models/tour.dart';
import '../../util/map_geo_util.dart';

class CardDetailsWidget extends StatelessWidget {
  final Tour tour;

  const CardDetailsWidget({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    return Flexible(
      fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Card(
          elevation: 4.0,
          child: Column(
            children: [
              ListTile(
                title: const Text('Start time'),
                subtitle: Text('${tour.startTime}'),
                trailing: const Icon(Icons.flag_outlined),
              ),
              ListTile(
                title: const Text('End time'),
                subtitle: Text('${tour.endTime}'),
                trailing: const Icon(Icons.flag_sharp),
              ),
              ListTile(
                title: const Text('Total total'),
                subtitle: Text('${tour.totalTime}'),
                trailing: const Icon(Icons.event_available),
              ),
              ExpansionTile(
                title: const Text('Pause'),
                subtitle: const Text('Click to view pauses'),
                trailing: const Icon(Icons.pause_circle_outlined),
                children: [
                  FutureBuilder<QuerySnapshot>(
                    future: fireService.getPauseFromTour(tour.tourId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final pauseData = Pause.fromMap(
                                data[index].data() as Map<String, dynamic>);
                            final startTime = pauseData.startTime;
                            final endTime = pauseData.endTime;
                            return ListTile(
                              title: Text('Pause no. ${index + 1}'),
                              subtitle: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text('Start time: $startTime'),
                                    Text('End time: $endTime'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Check points'),
                subtitle: const Text('Click to view check points'),
                trailing: const Icon(Icons.not_listed_location),
                children: [
                  FutureBuilder<QuerySnapshot>(
                    future: fireService.getCheckPointFromTour(tour.tourId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final checkPointData = CheckPoint.fromMap(
                                data[index].data() as Map<String, dynamic>);
                            return FutureBuilder<String>(
                              future: getAddressFromLatLong(
                                  checkPointData.truckStop),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  return ListTile(
                                    title: Text(
                                        'Check point no. ${index + 1}'),
                                    subtitle: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(snapshot.data!)),
                                    trailing: const Icon(
                                        Icons.location_on_rounded),
                                  );
                                } else {
                                  return Container(
                                    padding:
                                    const EdgeInsets.only(left: 16.0),
                                    alignment: Alignment.centerLeft,
                                    child:
                                    const CircularProgressIndicator(),
                                  );
                                }
                              },
                            );
                          },
                        );
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                ],
              ),
              FutureBuilder<String>(
                future: getAddressFromLatLong(tour.startPoint),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text('From: ${snapshot.data!}'),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      alignment: Alignment.centerLeft,
                      child: const CircularProgressIndicator(),
                    );
                  }
                },
              ),
              FutureBuilder<String>(
                future: getAddressFromLatLong(tour.endPoint),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text('To: ${snapshot.data!}'),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      alignment: Alignment.centerLeft,
                      child: const CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

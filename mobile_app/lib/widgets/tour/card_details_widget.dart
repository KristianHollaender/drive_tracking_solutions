import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/models/check_point.dart';
import 'package:drive_tracking_solutions/util/calender_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/pause.dart';
import '../../models/tour.dart';
import '../../util/map_geo_util.dart';

class CardDetailsWidget extends StatelessWidget {
  final Tour tour;
  final TextEditingController notesController = TextEditingController();

  CardDetailsWidget({Key? key, required this.tour}) : super(key: key);

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
              _buildNoteField(),
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
              _buildPausePanel(fireService),
              _buildCheckPointPanel(fireService),
              _buildLocator(tour.startPoint, 'From'),
              _buildLocator(tour.endPoint, 'To'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return StreamBuilder<DocumentSnapshot>(
      stream: fireService.getTourSnapshotStream(tour.tourId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final tourData = snapshot.data!.data() as Map<String, dynamic>;
          final tourNote = tourData['note'] as String?;
          notesController.text = tourNote ?? '';
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Add Note to Tour',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextField(
                        maxLines: null,
                        maxLength: 50,
                        controller: notesController,
                        onSubmitted: (value) async {
                          await fireService.addNote(tour.tourId, value.trim()).then(
                                (value) => {
                                  SystemChannels.textInput
                                      .invokeListMethod('TextInput.hide'),
                                },
                              );
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send), // Add send icon
                  onPressed: () async {
                    await fireService
                        .addNote(tour.tourId, notesController.text.trim())
                        .then(
                          (value) => {
                            SystemChannels.textInput
                                .invokeListMethod('TextInput.hide'),
                          },
                        );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  FutureBuilder<String> _buildLocator(GeoPoint point, String text) {
    return FutureBuilder<String>(
      future: getAddressFromLatLong(point),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Container(
            padding: const EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: Text('$text ${snapshot.data!}'),
          );
        } else {
          return Container(
            padding: const EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ExpansionTile _buildCheckPointPanel(FirebaseService fireService) {
    return ExpansionTile(
      title: const Text('Check points'),
      subtitle: const Text('Click to view check points'),
      trailing: const Icon(Icons.not_listed_location),
      textColor: const Color(0xff41a949),
      iconColor: const Color(0xff41a949),
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
                    future: getAddressFromLatLong(checkPointData.truckStop),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return ListTile(
                          title: Text('Check point no. ${index + 1}'),
                          subtitle: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(snapshot.data!)),
                          trailing: const Icon(Icons.location_on_rounded),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.only(left: 16.0),
                          alignment: Alignment.centerLeft,
                          child: const CircularProgressIndicator(),
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
    );
  }

  ExpansionTile _buildPausePanel(FirebaseService fireService) {
    return ExpansionTile(
      title: const Text('Pause'),
      subtitle: const Text('Click to view pauses'),
      trailing: const Icon(Icons.pause_circle_outlined),
      textColor: const Color(0xff41a949),
      iconColor: const Color(0xff41a949),
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
                  final pauseData =
                      Pause.fromMap(data[index].data() as Map<String, dynamic>);
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
    );
  }
}

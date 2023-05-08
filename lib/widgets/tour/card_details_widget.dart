import 'package:drive_tracking_solutions/widgets/tour/tour_map.dart';
import 'package:flutter/material.dart';
import '../../models/tour.dart';
import '../../util/map_geo_util.dart';

class CardDetailsWidget extends StatelessWidget {
  final Tour tour;
  const CardDetailsWidget({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        children: [
          SizedBox(height: 400.0, child: TourMap(tour: tour)),
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
          FutureBuilder<String>(
            future: getAddressFromLatLong(tour.startPoint, tour.endPoint),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(snapshot.data!),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: const CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

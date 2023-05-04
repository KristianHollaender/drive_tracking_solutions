import 'package:flutter/material.dart';

import '../models/tour.dart';

class TourDetails extends StatelessWidget {
  final Tour tour;

  const TourDetails({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tour.uid),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '${tour.startTime?.day} ${tour.getMonth(tour.startTime!)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: tour.endTime != null
                    ? Text(
                    '${tour.endTime?.hour}:${tour.endTime?.minute}:${tour.endTime?.second}')
                    : const Text('Tour is still going'),
              ),
            ),
          ],
        ),
      )
    );
  }
}

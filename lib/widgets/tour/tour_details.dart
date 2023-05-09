import 'package:flutter/material.dart';

import '../../models/tour.dart';
import 'card_details_widget.dart';

class TourDetails extends StatelessWidget {
  final Tour tour;
  final String id;

  const TourDetails({Key? key, required this.tour, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(tour.tourId),
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
                    fontSize: 35,
                  ),
                ),
              ),
              CardDetailsWidget(
                tour: tour,
              ),
            ],
          ),
        ));
  }
}

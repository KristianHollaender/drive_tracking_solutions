import 'package:flutter/material.dart';

import '../../models/tour.dart';
import 'card_details_widget.dart';

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
              CardDetailsWidget(
                tour: tour,
              ),
            ],
          ),
        ));
  }
}

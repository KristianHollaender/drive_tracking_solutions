import 'package:drive_tracking_solutions/widgets/tour/calendar.dart';
import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCalendar - Events'),
        actions: [
          IconButton(onPressed: (){

          }, icon: const Icon(Icons.newspaper))
        ],
      ),
      body: const CalendarWidget(),
    );
  }
}

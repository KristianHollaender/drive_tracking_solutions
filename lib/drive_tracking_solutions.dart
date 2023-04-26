import 'package:drive_tracking_solutions/screens/mobile/mobile_start_screen.dart';
import 'package:drive_tracking_solutions/screens/responsive/responsive_layout.dart';
import 'package:drive_tracking_solutions/screens/tablet/tablet_screen.dart';
import 'package:flutter/material.dart';

class DriveTrackingSolution extends StatefulWidget {
  const DriveTrackingSolution({Key? key}) : super(key: key);

  @override
  State<DriveTrackingSolution> createState() => _DriveTrackingSolutionState();
}

class _DriveTrackingSolutionState extends State<DriveTrackingSolution> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileApp: MobileApp(),
        tabletApp: TabletApp(),
      ),
    );
  }
}

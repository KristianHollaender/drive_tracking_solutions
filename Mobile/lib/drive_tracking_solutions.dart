import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:flutter/material.dart';

class DriveTrackingSolution extends StatefulWidget {
  const DriveTrackingSolution({Key? key}) : super(key: key);

  @override
  State<DriveTrackingSolution> createState() => _DriveTrackingSolutionState();
}

class _DriveTrackingSolutionState extends State<DriveTrackingSolution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileLoginScreen(),
    );
  }
}

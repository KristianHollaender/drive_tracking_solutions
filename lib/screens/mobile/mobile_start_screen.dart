import 'package:drive_tracking_solutions/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({Key? key}) : super(key: key);

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello',
          style: TextStyle(fontSize: 50),
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

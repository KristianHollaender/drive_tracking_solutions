import 'package:drive_tracking_solutions/screens/mobile/mobile_home_screen.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_start_screen.dart';
import 'package:drive_tracking_solutions/widgets/bottom_nav_bar.dart';import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      home: const MobileApp(),
    );
  }
}

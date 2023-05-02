import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_overview_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(),
      home: const SafeArea(top: true, child: MobileLoginScreen()),
    );
  }
}

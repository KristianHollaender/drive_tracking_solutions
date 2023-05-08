import 'package:drive_tracking_solutions/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MobileStartScreen extends StatelessWidget {
  const MobileStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
      bottomNavigationBar: NavBar(),
    );
  }
}
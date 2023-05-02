import 'package:flutter/material.dart';

import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "HomeScreen",
          style: TextStyle(fontSize: 50),
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

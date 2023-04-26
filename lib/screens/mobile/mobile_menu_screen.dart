import 'package:flutter/material.dart';

import '../../widgets/bottom_nav_bar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
            "MenuScreen",
            style: TextStyle(fontSize: 50),
          )),
    );
  }
}

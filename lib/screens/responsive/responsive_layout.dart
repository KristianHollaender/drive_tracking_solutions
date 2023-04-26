import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileApp;
  final Widget tabletApp;

  const ResponsiveLayout(
      {Key? key, required this.mobileApp, required this.tabletApp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth <= 600) {
        return mobileApp;
      } else{
        return tabletApp;
      }
    });
  }
}

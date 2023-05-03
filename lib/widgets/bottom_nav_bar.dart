import 'package:drive_tracking_solutions/screens/mobile/mobile_home_screen.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_menu_screen.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_overview_screen.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 1;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    Center(
      child: OverviewScreen(),
    ),
    Center(
      child: HomeScreen(),
    ),
    Center(
      child: MenuScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top:5.0, bottom: 5.0),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Overview'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../widgets/bottom_nav_bar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          CircleAvatar(
            radius: 50,
            child: ClipOval(
              child: Image.asset(
                'assets/46.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 8.0),
                Text(
                  "Name Lastname", //TODO Make logged in name appear here
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  "Email@mail.com", //TODO Make logged in email appear here
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // TODO Log out function
                  },
                  child: Text('Log out'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

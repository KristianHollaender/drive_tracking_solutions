import 'package:flutter/material.dart';

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 200.0,
                  height: 200.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      //TODO Make login function
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // TODO Make reset password function
                    },
                    child: Text('Reset Password'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

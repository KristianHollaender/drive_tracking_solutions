import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_new_user_screen.dart';
import 'package:drive_tracking_solutions/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/fire_service.dart';
import 'mobile_reset_password_screen.dart';

class MobileLoginScreen extends StatelessWidget {
  MobileLoginScreen({super.key});

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Form(
            key: _formKey,
            child: _buildUserInputs(context),
          ),
        ),
      ),
    );
  }

  Column _buildUserInputs(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            child: Image.asset('assets/Logo-lighter.png',
                width: 400.0, height: 375.0),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          width: 315,
          child: emailInput(),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 25),
          width: 315,
          child: passwordInput(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  signUpBtn(context),
                  loginBtn(context),
                ],
              ),
            ),
            forgotPasswordBtn(context),
          ],
        )
      ],
    );
  }

  TextButton forgotPasswordBtn(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(const Color(0xff26752b)),
      ),
      child: const Text('Forgot Password?'),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileResetPasswordScreen(),
          ),
        );
      },
    );
  }

  SizedBox loginBtn(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    return SizedBox(
      width: 150.0,
      child: FloatingActionButton.extended(
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          final email = _email.value.text;
          final password = _password.value.text;
            await fireService.signIn(email, password);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const NavBar(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logged in successfully'),
              ),
            );
        },
        backgroundColor: const Color(0xff26752b),
        label: const Text("Log in"),
      ),
    );
  }

  SizedBox signUpBtn(BuildContext context) {
    return SizedBox(
      width: 150.0,
      child: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MobileNewUserScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xff26752b),
        label: const Text('Sign up'),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      style: TextStyle(fontSize: 18),
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(fontSize: 20, color: Colors.white),
        prefixIcon: Icon(Icons.email, size: 28),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      validator: (value) =>
      (value == null || !value.contains("@")) ? 'Email required' : null,
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _password,
      style: TextStyle(fontSize: 18),
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(fontSize: 20, color: Colors.white),
        prefixIcon: Icon(Icons.lock, size: 28),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      obscureText: true,
      validator: (value) =>
      (value == null || value.length < 6) ? 'Password required (min 6 chars)' : null,
    );
  }


}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_new_user_screen.dart';
import 'package:drive_tracking_solutions/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../fire_service.dart';
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
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  child:
                      Image.asset('assets/logo.png', width: 300.0, height: 300.0),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: emailInput(),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: passwordInput(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    loginBtn(context),
                    createUserBtn(context),
                    forgotPasswordBtn(context),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton forgotPasswordBtn(BuildContext context) {
    return TextButton(
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

  ElevatedButton loginBtn(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    return ElevatedButton(
      child: const Text('Login'),
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        final email = _email.value.text;
        final password = _password.value.text;
        try {
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
        } on FirebaseException catch (e) {
          String errorMessage = 'An error occurred, please try again later.';
          if (e.code == 'user-not-found') {
            errorMessage = 'The email you entered does not exist.';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'The password you entered is incorrect.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  ElevatedButton createUserBtn(BuildContext context) {
    return ElevatedButton(
      child: const Text('Create new account'),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileNewUserScreen(),
          ),
        );
      },
    );
  }


  TextFormField emailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      decoration: const InputDecoration(label: Text('Email')),
      validator: (value) =>
          (value == null || !value.contains("@")) ? 'Email required' : null,
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _password,
      decoration: const InputDecoration(label: Text('Password')),
      obscureText: true,
      validator: (value) => (value == null || value.length < 6)
          ? 'Password required (min 6 chars)'
          : null,
    );
  }
}

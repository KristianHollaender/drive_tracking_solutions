import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_new_user_screen.dart';
import 'package:drive_tracking_solutions/widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../fire_service.dart';
import 'mobile_reset_password_screen.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() =>
      _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
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
                    createUserBtn(),
                    forgotPasswordBtn(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton forgotPasswordBtn() {
    return TextButton(
      child: const Text('Forgot Password?'),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MobileResetPasswordScreen(),
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
          setState(() {});
          return;
        }
        final email = _email.value.text;
        final password = _password.value.text;
        fireService.signIn(email, password);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const NavBar(),
          ),
        );
      },
    );
  }

  ElevatedButton createUserBtn() {
    return ElevatedButton(
      child: const Text('Create new account'),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MobileNewUserScreen(),
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

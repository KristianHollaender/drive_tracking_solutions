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
        const SizedBox(
          height: 25.0,
        ),
        Center(
          child: Image.asset('assets/Logo-lighter.png',
              width: 400.0, height: 375.0),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          width: MediaQuery
              .of(context)
              .size
              .width * 0.85,
          child: emailInput(),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 28),
          width: MediaQuery
              .of(context)
              .size
              .width * 0.85,
          child: passwordInput(context),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    signUpBtn(context),
                    loginBtn(context),
                  ],
                ),
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
        foregroundColor:
        MaterialStateProperty.all<Color>(const Color(0xff26752b)),
      ),
      child: const Text('Forgot Password?', style: TextStyle(fontSize: 16),),
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
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.41,
      child: FloatingActionButton.extended(
        key: const Key('loginBtn'),
        heroTag: 'loginBtn',
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          await _login(context);
        },
        backgroundColor: const Color(0xff26752b),
        label: const Text("Log in", style: TextStyle(fontSize: 17),),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final fireService = Provider.of<FirebaseService>(context, listen: false);

    final email = _email.value.text;
    final password = _password.value.text;

    try {
      await fireService.signIn(email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged in successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const NavBar(),
        ),
      );
    }catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login unsuccessful, email or password is incorrect'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  SizedBox signUpBtn(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.41,
      child: FloatingActionButton.extended(
        heroTag: 'signUpBtn',
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MobileNewUserScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xff26752b),
        label: const Text('Sign up', style: TextStyle(fontSize: 17)),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      key: const Key('emailInput'),
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      style: const TextStyle(fontSize: 18),
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

  TextFormField passwordInput(BuildContext context) {
    return TextFormField(
      key: const Key('passwordInput'),
      controller: _password,
      style: const TextStyle(fontSize: 18),
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
      (value == null || value.length < 6)
          ? 'Password required (min 6 chars)'
          : null,
      onFieldSubmitted: (_) => _login(context),
    );
  }
}

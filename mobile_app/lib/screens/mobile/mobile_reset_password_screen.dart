import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/fire_service.dart';

class MobileResetPasswordScreen extends StatelessWidget {
  const MobileResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    final emailController = TextEditingController();

    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0, top: 20),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Image.asset(
                        'assets/Logo-lighter.png',
                        width: MediaQuery.of(context).size.width * 0.75,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
                  child: Text("By writing your email and pressing send - "),
                ),
                const Padding(
                  padding: EdgeInsets.only(left:4.0, bottom: 40),
                  child: Text("a password reset link will be sent via email")
                ),
                _emailInput(emailController),
                const SizedBox(height: 16.0),
                _buildResetPasswordBtn(emailController, fireService, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordBtn(TextEditingController emailController,
      FirebaseService fireService, BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final email = emailController.text.trim();
        if (email.isNotEmpty) {
          try {
            await fireService.resetPassword(email);
            _showSuccessSnackBar(context, 'Email sent to $email');
          } catch (e) {
            _showErrorSnackBar(context, 'The email doesn\'t exist');
          }
        } else {
          _showErrorSnackBar(context, 'Please enter an email');
        }
      },
      label: const Text('Send'),
      backgroundColor: const Color(0xff26752b),
    );
  }


  Widget _emailInput(TextEditingController controller) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
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

  void _showErrorSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.green,
      ),
    );
  }
}

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _emailInput(emailController),
              const SizedBox(height: 16.0),
              _buildResetPasswordBtn(emailController, fireService, context),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildResetPasswordBtn(TextEditingController emailController,
      FirebaseService fireService, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final email = emailController.text.trim();
        if (email.isNotEmpty) {
          fireService.resetPassword(email);
          _showSuccessSnackBar(context, 'Email sent to $email');
        } else {
          _showErrorSnackBar(context, 'Please enter an email');
        }
      },
      child: const Text('Send'),
    );
  }

  Widget _emailInput(TextEditingController controller) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: const InputDecoration(labelText: 'Email'),
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

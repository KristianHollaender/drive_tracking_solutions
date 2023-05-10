import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../fire_service.dart';

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
          title: Text('Reset Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              emailInput(emailController),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  if (email.isNotEmpty) {
                    fireService.resetPassword(email);
                  }
                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailInput(TextEditingController controller) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) =>
      (value == null || !value.contains("@")) ? 'Email required' : null,
    );
  }
}

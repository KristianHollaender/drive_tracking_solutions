import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockFirebaseService extends FirebaseService {

}

void main() {
  testWidgets('Login Screen - Email and Password Input Validation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Provider<FirebaseService>(
          create: (_) => MockFirebaseService(), // Provide the mock implementation
          child: MobileLoginScreen(),
        ),
      ),
    );

    // Find the email and password text fields
    final emailField = find.widgetWithText(TextFormField, 'Email');
    final passwordField = find.widgetWithText(TextFormField, 'Password');

    // Enter valid email and password
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password');

    // Trigger the login button press
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.tap(loginButton);
    await tester.pump();

    // Verify that the login process is successful
    expect(find.text('Logged in successfully'), findsOneWidget);

    // Enter invalid email (without '@') and valid password
    await tester.enterText(emailField, 'invalid_email');
    await tester.enterText(passwordField, 'password');

    // Trigger the login button press
    await tester.tap(loginButton);
    await tester.pump();

    // Verify that the email validation error message is shown
    expect(find.text('Email required'), findsOneWidget);

    // Enter valid email and invalid password (less than 6 characters)
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'pass');

    // Trigger the login button press
    await tester.tap(loginButton);
    await tester.pump();

    // Verify that the password validation error message is shown
    expect(find.text('Password required (min 6 chars)'), findsOneWidget);
  });
}

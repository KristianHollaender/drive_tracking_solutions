import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

@GenerateNiceMocks([MockSpec<FirebaseService>(), MockSpec<NavigatorObserver>()])
import 'widget_test.mocks.dart';

void main() {
  testWidgets('valid email and password', (tester) async {
    final firebaseService = MockFirebaseService();
    final mockNavigatorObserver = MockNavigatorObserver();

    await tester.pumpWidget(Provider<FirebaseService>.value(
      value: firebaseService,
      child: MaterialApp(
        home: MobileLoginScreen(),
        navigatorObservers: [mockNavigatorObserver],
      ),
    ));

    await tester.enterText(find.byKey(const Key('emailInput')), 'test@mail.dk');
    await tester.enterText(find.byKey(const Key('passwordInput')), '123123');
    await tester.pump();
    await tester.tap(find.byKey(const Key('loginBtn')));

    verify(firebaseService.signIn('test@mail.dk', '123123'));
  });

  testWidgets('invalid email format', (tester) async {
    final firebaseService = MockFirebaseService();
    final mockNavigatorObserver = MockNavigatorObserver();

    await tester.pumpWidget(Provider<FirebaseService>.value(
      value: firebaseService,
      child: MaterialApp(
        home: MobileLoginScreen(),
        navigatorObservers: [mockNavigatorObserver],
      ),
    ));

    await tester.enterText(find.byKey(const Key('emailInput')), 'invalid_email');
    await tester.enterText(find.byKey(const Key('passwordInput')), '123123');
    await tester.pump();
    await tester.tap(find.byKey(const Key('loginBtn')));

    verifyNever(firebaseService.signIn(any, any));
  });

  testWidgets('password shorter than 6 characters', (tester) async {
    final firebaseService = MockFirebaseService();
    final mockNavigatorObserver = MockNavigatorObserver();

    await tester.pumpWidget(Provider<FirebaseService>.value(
      value: firebaseService,
      child: MaterialApp(
        home: MobileLoginScreen(),
        navigatorObservers: [mockNavigatorObserver],
      ),
    ));

    await tester.enterText(find.byKey(const Key('emailInput')), 'test@mail.dk');
    await tester.enterText(find.byKey(const Key('passwordInput')), '123');
    await tester.pump();
    await tester.tap(find.byKey(const Key('loginBtn')));

    verifyNever(firebaseService.signIn(any, any));
  });
}

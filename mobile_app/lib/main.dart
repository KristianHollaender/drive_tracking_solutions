import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/firebase_options.dart';
import 'package:drive_tracking_solutions/logic/drive_tracking.dart';
import 'package:drive_tracking_solutions/logic/gas_station_repo.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        Provider(create: (context) => FirebaseService()),
        Provider(create: (context) => DriveTracker()),
        Provider(create: (context) => GasStationRepo()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          theme: ThemeData.dark().copyWith(
            primaryColor: const Color(0xff07460b),
            useMaterial3: true,
          ),
          home: SafeArea(top: true, child: MobileLoginScreen()),
        );
      },
    );
  }
}

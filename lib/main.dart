import 'package:drive_tracking_solutions/fire_service.dart';
import 'package:drive_tracking_solutions/firebase_options.dart';
<<<<<<< Updated upstream
import 'package:drive_tracking_solutions/logic/excel_converter.dart';
=======
import 'package:drive_tracking_solutions/logic/drive_tracking.dart';
>>>>>>> Stashed changes
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:drive_tracking_solutions/widgets/gas_stations_widget.dart';
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
<<<<<<< Updated upstream
        Provider(create: (context) => ExcelConverter()),
=======

        Provider(create: (context) => DriveTracker()),
>>>>>>> Stashed changes
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          theme: ThemeData(
            colorSchemeSeed: const Color(0xff07460b), useMaterial3: true,
          ),
          home: SafeArea(top: true, child: MobileLoginScreen()),
          //home: const SafeArea(top: true, child: GasStationWidget()),
        );
      },
    );
  }
}

import 'package:face_recognition_application/api/fetching/attandace_fetch.dart';
import 'package:face_recognition_application/screens/login_screen.dart';
import 'package:face_recognition_application/utils/navigation.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //

  // Run the app after initializations are complete
  await Attendance.initialize();

  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('token');
  // final initialRoute = authToken != null ? '/attendance' : '/login';

  var initialRoute = "/login";
  runApp(MainApp(initialRoute: initialRoute));
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/attendance': (context) => const Navigation(),
      },
    );
  }
}

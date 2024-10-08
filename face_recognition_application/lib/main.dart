import 'package:face_recognition_application/api/fetching/attandace_fetch.dart';
import 'package:face_recognition_application/provider/attendance_provider.dart';
import 'package:face_recognition_application/screens/login_screen.dart';
import 'package:face_recognition_application/screens/unauthorized_screen.dart';
import 'package:face_recognition_application/utils/navigation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Attendance.initialize();

  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('token');
  final initialRoute = authToken != null ? '/attendance' : '/login';

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AttendanceProvider()),
          ],
      child: MainApp(initialRoute: initialRoute),
  ));
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/attendance': (context) => const Navigation(),
        '/unauthorized' : (context) => const UnauthorizedScreen(),
      },
    );
  }
}

import 'package:face_recognition_application/api/fetching/recognition_fetch.dart';
import 'package:face_recognition_application/screens/attendance_screen.dart';
import 'package:face_recognition_application/screens/login_screen.dart';
import 'package:face_recognition_application/utils/navigation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Make sure binding is initialized

  // Initialize Firebase

  // Initialize Recognition API
  await Recognition.initialize();

  // Run the app after initializations are complete
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Navigation(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:face_recognition_application/font/font_style.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: FontStyle.buildText("history", screenWidth / 18, Colors.black),
    );
  }
}

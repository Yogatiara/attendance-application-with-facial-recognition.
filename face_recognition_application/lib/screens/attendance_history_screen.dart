import 'package:flutter/material.dart';
import 'package:face_recognition_application/font/font_style.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 60),
          child: Text("My Attendance", style: FontStyle.textStyle(
              25, Colors.redAccent, FontWeight.w600),
          )
        ),
        Container(
            child: Row(

            ),
        )


      ],
    );
  }
}

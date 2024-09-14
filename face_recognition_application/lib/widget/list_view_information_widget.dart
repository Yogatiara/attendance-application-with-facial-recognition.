import 'package:face_recognition_application/font/font_style.dart';
import 'package:flutter/material.dart';


class ListViewInformation {
  static listViewErrorBuilder(double screenSize, dynamic object ) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: screenSize / 1.15,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/server_error.jpg',
                  width: 350,
                  height: 250,
                ),
                Text(
                  object.detail,
                  style: FontStyle.textStyle(
                      40, Colors.redAccent, FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
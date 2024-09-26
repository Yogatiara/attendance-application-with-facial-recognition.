import 'package:flutter/material.dart';
import 'package:face_recognition_application/font/font_style.dart';

class Button {
  static okButton(BuildContext context) {
    return  ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent

        ) ,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child:Text("OK",
          style: FontStyle.textStyle(
              17, Colors.white, FontWeight.w600),
        ) );
  }
}
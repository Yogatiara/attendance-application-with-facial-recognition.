import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyle {
  static TextStyle textStyle(
          double fontSize, Color fontColor, FontWeight fontWeight) =>
      GoogleFonts.firaSans(
          fontSize: fontSize, color: fontColor, fontWeight: fontWeight);

  static Text buildText(String text, double fontSize, Color fontColor) => Text(
        text,
        style: GoogleFonts.firaSans(
          fontSize: fontSize,
          color: fontColor,
        ),
      );
}

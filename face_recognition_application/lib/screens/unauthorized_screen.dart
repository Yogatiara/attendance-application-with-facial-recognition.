import 'package:face_recognition_application/font/font_style.dart';
import 'package:face_recognition_application/utils/jump_to_login.dart';
import 'package:flutter/material.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({super.key});

  Future<void> navigateToLogin(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3), () {
      jumpToLogin(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    navigateToLogin(context);

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/unauthorized.png',
                width: 350,
                height: 350,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal:46),
                child: Text(
                  textAlign: TextAlign.center,
                  "Your session has expired, please log in again",
                  style: FontStyle.textStyle(
                      30, Colors.redAccent, FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

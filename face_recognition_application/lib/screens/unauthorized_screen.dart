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
                'assets/images/Unauthorized.png',
                width: 350,
                height: 350,
              ),
              Text(
                textAlign: TextAlign.center,
                "Your session has expired, please log in again",
                style: FontStyle.textStyle(
                    35, Colors.redAccent, FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

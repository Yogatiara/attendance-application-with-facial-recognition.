import 'package:flutter/material.dart';
import 'package:face_recognition_application/font/font_style.dart';

class DialogWidget {
  static dialogBuilder(BuildContext context, dynamic object, error) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Container(
              padding:  EdgeInsets.all(error ? 8 :10),
              child: error? Column(
                children: [
                  Image.asset(
                   object.statusCode == 400?  "assets/icons/face-unknown.png":
                   "assets/icons/forbidden-attendance.png",
                    height: object.statusCode == 400?200: 150,
                    width: object.statusCode == 400?200: 150,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                      textAlign: TextAlign.center,
                    "${object.detail.toString()}!!",
                    style:
                        FontStyle.textStyle(20, Colors.redAccent, FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  object.statusCode == 400
                      ? Text(
                          "Note: Please take a photo of your face again",
                          style: FontStyle.textStyle(
                              15, Colors.black45, FontWeight.w400),
                        )
                      : Text(
                    "Note: Please Take attendance tomorrow  ",
                    style: FontStyle.textStyle(
                        15, Colors.black45, FontWeight.w400),
                  )
                ],
              ) : Column(
                children: [
                  Image.asset(
                    "assets/icons/success.png",
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "${object.message}",
                    style: FontStyle.textStyle(20, Colors.green, FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft, // Pastikan alignment diatur ke kiri
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Agar teks diatur ke kiri
                      children: [
                        Text(
                          "Name : ${object.userName}",
                          style: FontStyle.textStyle(
                              15, Colors.black54, FontWeight.w400),
                        ),
                        Text(
                          "NIM : ${object.nim}",
                          style: FontStyle.textStyle(
                              15, Colors.black54, FontWeight.w400),
                        ),
                        Text(
                          "Status : ${object.status}",
                          style: FontStyle.textStyle(
                              15, Colors.black54, FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                'Oke',
                style:
                    FontStyle.textStyle(20, Colors.black54, FontWeight.w500),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

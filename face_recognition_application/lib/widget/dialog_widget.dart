import 'package:face_recognition_application/utils/capitalize_each_word.dart';
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
                   "assets/images/forbidden_attendance.png",
                    height: object.statusCode == 400?200: 300,
                    width: object.statusCode == 400?200: 300,
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
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name : ${capitalizeEachWord(object.userName)}",
                          style: FontStyle.textStyle(
                              15, Colors.black54, FontWeight.w400),
                        ),
                        Text(
                          "NIM : ${object.nim}",
                          style: FontStyle.textStyle(
                              15, Colors.black54, FontWeight.w400),
                        ),
                        Text(
                          "action : ${object.action}",
                          style: FontStyle.textStyle(
                              15, Colors.black54, FontWeight.w400),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'status: ',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: object.status,
                                style: TextStyle(
                                  color: object.status == "on time"?Colors.green
                                  : object.status == "late"? Colors.red: Colors.black54,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "**${object.action} at ${(object.dateTime).split(",")[0]}",
                          style: FontStyle.textStyle(
                              17, Colors.black54, FontWeight.w500),
                        ),
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
                    FontStyle.textStyle(20, Colors.black87, FontWeight.w500),
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

import 'package:face_recognition_application/utils/capitalize_each_word.dart';
import 'package:face_recognition_application/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:face_recognition_application/font/font_style.dart';

class DialogWidget {
  static dialogBuilder(BuildContext context, dynamic object, error) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
        child: SingleChildScrollView(
              padding:  EdgeInsets.all(error ? 40 :10),
              child: error? Column(

                children: [
                  Image.asset(
                    object.detail.toString() == "you are out of range" && object.statusCode == 403?
                    "assets/icons/not-found.png":
                   object.statusCode == 400?
                   "assets/icons/face-unknown.png":
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
                Text(
                  "Note: ${object.statusCode == 400?"Please take a photo of your face again":
                  object.detail.toString() == "you are out of range" && object.statusCode == 403?
                  "make sure you enter the campus area": "Please take attendance tomorrow "}",
                  style: FontStyle.textStyle(15, Colors.black45, FontWeight.w400),
                ),

                  const SizedBox(height: 40,),
                  SizedBox(

                    width: double.maxFinite,
                    child: Button.okButton(context) ,
                  )


                ],
              ) : Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                            border: Border(
                            bottom: BorderSide(color: Colors.black26),
                            ),
                        ),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                            children: [
                              Text(
                                "Name:",
                                style: FontStyle.textStyle(
                                    17, Colors.black54, FontWeight.w500),
                              ),

                              Text(
                                capitalizeEachWord(object.userName),
                                style: FontStyle.textStyle(
                                    17, Colors.black54, FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black26),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                            children: [
                              Text(
                                "NIM:",
                                style: FontStyle.textStyle(
                                    17, Colors.black54, FontWeight.w500),
                              ),

                              Text(
                                "${object.nim}",
                                style: FontStyle.textStyle(
                                    17, Colors.black54, FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),

                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black26),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                            children: [
                              Text(
                                "Action:",
                                style: FontStyle.textStyle(
                                    17, Colors.black54, FontWeight.w500),
                              ),

                              Text(
                                "${object.action}",
                                style: FontStyle.textStyle(
                                    17, Colors.black54, FontWeight.w400),
                              ),
                            ],
                          ),
                        ),const SizedBox(height: 10,),

                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black26),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                            children: [
                              Text(
                                "Status:",
                                style: FontStyle.textStyle(
                                    17, Colors.black54, FontWeight.w500),
                              ),

                              Text(
                                "${object.status}",
                                style: FontStyle.textStyle(
                                    17, object.status == "on time"?Colors.green
                                    : object.status == "late"? Colors.red: Colors.black54, FontWeight.w600),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20,),
                        Text(
                          "**${object.action} at ${(object.dateTime).split(",")[0]}",
                          style: FontStyle.textStyle(
                              17, Colors.redAccent, FontWeight.w600),
                        ),
                        const SizedBox(height: 30,),


                        Center(
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Button.okButton(context),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: -80,
                      child: Image.asset(
                          "assets/icons/success.png",
                          height: 150,
                          width: 150,
                      ),
                  )
                ],
              ),
            ),

        );
      },
    );
  }
}

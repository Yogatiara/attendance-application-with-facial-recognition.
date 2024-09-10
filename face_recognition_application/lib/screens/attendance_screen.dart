import 'package:face_recognition_application/font/font_style.dart';
import 'package:face_recognition_application/provider/attendance_provider.dart';
import 'package:face_recognition_application/provider/date_time_provider.dart';
import 'package:face_recognition_application/provider/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DateTimeProvider()),
        ChangeNotifierProvider(
          create: (context) => AttendanceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 32),
              child: Consumer<UserProvider>(
                builder: (BuildContext content, UserProvider userProvider, _) =>
                    Column(
                  children: [
                    FontStyle.buildText(
                        "Welcome", screenWidth / 20, Colors.black54),
                    FontStyle.buildText(
                        "Student", screenWidth / 17, Colors.redAccent),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 32),
              child: FontStyle.buildText(
                  "Today's status", screenWidth / 18, Colors.black),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 15),
              height: 85,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 2))
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Consumer<DateTimeProvider>(
                builder: (BuildContext context,
                        DateTimeProvider dateTimeProvider, _) =>
                    Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FontStyle.buildText(
                            "Check in", screenWidth / 20, Colors.black54),
                        FontStyle.buildText(
                            dateTimeProvider.chekInTime?.split(" ")[0] ??
                                "--/--",
                            screenWidth / 20,
                            Colors.black54)
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FontStyle.buildText(
                            "Check out", screenWidth / 20, Colors.black54),
                        FontStyle.buildText(
                            dateTimeProvider.chekOutTime?.split(" ")[0] ??
                                "--/--",
                            screenWidth / 20,
                            Colors.black54)
                      ],
                    ))
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Consumer<DateTimeProvider>(
                builder: (BuildContext context,
                        DateTimeProvider dateTimeProvider, _) =>
                    RichText(
                        text: TextSpan(
                            text: dateTimeProvider.formattedDate?.split(" ")[0],
                            style: FontStyle.textStyle(screenWidth / 25,
                                Colors.redAccent, FontWeight.w500),
                            children: [
                      TextSpan(
                          text:
                              " ${dateTimeProvider.formattedDate?.split(" ")[1]} ${dateTimeProvider.formattedDate?.split(" ")[2]}",
                          style: FontStyle.textStyle(
                              screenWidth / 25, Colors.black, FontWeight.w500))
                    ])),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Consumer<DateTimeProvider>(
                  builder: (BuildContext context,
                          DateTimeProvider dateTimeProvider, _) =>
                      FontStyle.buildText(
                          dateTimeProvider.formattedTime.toString(),
                          screenWidth / 20,
                          Colors.black54),
                )),
            // Container(
            //   margin: const EdgeInsets.symmetric(vertical: 15),
            //   width: screenWidth / 1.2,
            //   child: Builder(
            //     builder: (context) {
            //       final GlobalKey<SlideActionState> _key = GlobalKey();
            //       return Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Consumer<AttendanceProvider>(
            //           builder: (BuildContext context,
            //                   AttendanceProvider attendanceProvider, _) =>
            //               Consumer<SlideActionProvider>(
            //             builder: (BuildContext context,
            //                     SlideActionProvider slideActionProvider, _) =>
            //                 Consumer<DateTimeProvider>(
            //               builder: (BuildContext context,
            //                       DateTimeProvider dateTimeProvider, _) =>
            //                   SlideAction(
            //                       text: slideActionProvider.actionText,
            //                       textStyle: FontStyle.textStyle(
            //                           screenWidth / 20,
            //                           Colors.redAccent,
            //                           FontWeight.w500),
            //                       outerColor: Colors.white,
            //                       innerColor: Colors.redAccent,
            //                       key: _key,
            //                       onSubmit: () async {
            //                         final now = DateTime.now();

            //                         final cutOffTimeStart = DateTime(
            //                             now.year, now.month, now.day, 7, 30);

            //                         final formattedTime = dateTimeProvider
            //                             .formattedTime
            //                             .toString()
            //                             .substring(0, 5);

            //                         if (now.isBefore(cutOffTimeStart)) {
            //                           ScaffoldMessenger.of(context)
            //                               .showSnackBar(
            //                             const SnackBar(
            //                               content: Text(
            //                                   "Absences cannot be made before half past 8 am."),
            //                             ),
            //                           );
            //                           return;
            //                         }

            //                         if (attendanceProvider.photoFile == null) {
            //                           ScaffoldMessenger.of(context)
            //                               .showSnackBar(
            //                             const SnackBar(
            //                               content: Text(
            //                                   "Please take a photo of your face."),
            //                             ),
            //                           );
            //                         } else if (attendanceProvider.photoFile !=
            //                             null) {
            //                           if (attendanceProvider.error == true) {
            //                             ScaffoldMessenger.of(context)
            //                                 .showSnackBar(
            //                               const SnackBar(
            //                                 content: Text(
            //                                     "your face is not recognized please try again"),
            //                               ),
            //                             );
            //                           } else {
            //                             if (slideActionProvider.actionText ==
            //                                 "Slide to check in") {
            //                               slideActionProvider.setText =
            //                                   "Slide to check out";
            //                               slideActionProvider.setAction =
            //                                   "check_in";
            //                             } else if (slideActionProvider
            //                                     .actionText ==
            //                                 "Slide to check out") {
            //                               slideActionProvider.setText =
            //                                   "Slide to check in";
            //                               slideActionProvider.setAction =
            //                                   "check_out";
            //                             }
            //                           }

            //                           attendanceProvider.attendance(
            //                             slideActionProvider.action ?? "",
            //                             formattedTime,
            //                           );
            //                         }
            //                       }),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Consumer<AttendanceProvider>(
                      builder: (BuildContext context,
                          AttendanceProvider attendanceProvider, _) {
                        return attendanceProvider.photoFile == null
                            ? Container(
                                width: 300,
                                height: 300,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icons/face-scan.png"))),
                              )
                            : SizedBox(
                                width: 300,
                                height: 300,
                                child: Image.file(
                                  attendanceProvider.photoFile!,
                                  fit: BoxFit.fitHeight,
                                ),
                              );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Consumer<AttendanceProvider>(
                        builder: (BuildContext context,
                                AttendanceProvider attendanceProvider, _) =>
                            TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      const CircleBorder()),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: () {
                                  // attendanceProvider.imagePicker();
                                  // attendanceProvider.attendance("", timeStamp)
                                },
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 50,
                                  color: Colors.redAccent,
                                )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

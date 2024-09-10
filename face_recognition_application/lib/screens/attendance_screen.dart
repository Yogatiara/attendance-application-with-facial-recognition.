import 'package:face_recognition_application/api/fetching/user_fetch.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:face_recognition_application/api/model/user_model.dart';
import 'package:face_recognition_application/font/font_style.dart';
import 'package:face_recognition_application/provider/attendance_provider.dart';
import 'package:face_recognition_application/provider/date_time_provider.dart';
import 'package:face_recognition_application/utils/capitalize_each_word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<dynamic> _userData() async {
    final token = await _getToken();
    if (token != null) {
      return await User.getUser(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final screenSize = MediaQuery.of(context).size;

    return FutureBuilder<dynamic>(
      future: _userData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              width: screenSize.width,
              height: screenSize
                  .height, // Opsional, untuk memberikan jarak antara animasi dan tepi latar belakang
              color: Colors.redAccent, // Latar belakang merah
              child: LoadingAnimationWidget.fourRotatingDots(
                  size: 90, color: Colors.white),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data is UserModel) {
            final data = snapshot.data as UserModel;

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => DateTimeProvider()),
                ChangeNotifierProvider(
                  create: (context) => AttendanceProvider(),
                ),
              ],
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FontStyle.buildText(
                              "Welcome", screenWidth / 20, Colors.black54),
                          FontStyle.buildText(
                              data.userName != null && data.userName!.isNotEmpty
                                  ? capitalizeEachWord(data.userName ?? "")
                                  : "Student",
                              screenWidth / 17,
                              Colors.redAccent),
                        ],
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
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.red.shade300,
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
                                    "Check in", screenWidth / 20, Colors.white),
                                FontStyle.buildText(
                                    dateTimeProvider.chekInTime
                                            ?.split(" ")[0] ??
                                        "--/--",
                                    screenWidth / 20,
                                    Colors.white)
                              ],
                            )),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FontStyle.buildText("Check out",
                                    screenWidth / 20, Colors.white),
                                FontStyle.buildText(
                                    dateTimeProvider.chekOutTime
                                            ?.split(" ")[0] ??
                                        "--/--",
                                    screenWidth / 20,
                                    Colors.white)
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
                                    text: dateTimeProvider.formattedDate
                                        ?.split(" ")[0],
                                    style: FontStyle.textStyle(screenWidth / 25,
                                        Colors.redAccent, FontWeight.w500),
                                    children: [
                              TextSpan(
                                  text:
                                      " ${dateTimeProvider.formattedDate?.split(" ")[1]} ${dateTimeProvider.formattedDate?.split(" ")[2]}",
                                  style: FontStyle.textStyle(screenWidth / 25,
                                      Colors.black, FontWeight.w500))
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
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
                                        AttendanceProvider attendanceProvider,
                                        _) =>
                                    TextButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              const CircleBorder()),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
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
          } else if (snapshot.data is ErrorModel) {
            final error = snapshot.data as ErrorModel;
            return Center(
              child: Text("Error: ${error.detail}"),
            );
          } else {
            return const Center(child: Text("Unexpected data format"));
          }
        } else {
          return const Center(child: Text("No user data available"));
        }
      },
    );
  }
}

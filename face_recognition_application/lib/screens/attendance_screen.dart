import 'package:face_recognition_application/api/fetching/attandace_fetch.dart';
import 'package:face_recognition_application/api/fetching/user_fetch.dart';
import 'package:face_recognition_application/api/model/attendance_model.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:face_recognition_application/api/model/user_model.dart';
import 'package:face_recognition_application/font/font_style.dart';
import 'package:face_recognition_application/provider/attendance_provider.dart';
import 'package:face_recognition_application/provider/date_time_provider.dart';
import 'package:face_recognition_application/utils/capitalize_each_word.dart';
import 'package:face_recognition_application/widget/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../widget/list_view_information_widget.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isLoading = false;
  dynamic _userData;
  dynamic _attendanceData;
  final DateTime _now = DateTime.now();
  late AttendanceProvider _attendanceProvider;



  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    final token = await _getToken();
    if (token != null) {
      var userData = await User.getUser(token);

      var attendanceData = await Attendance.getAttendanceByDateAndAction(
          DateFormat("dd MMM yyyy").format(_now),"", token);

      if (userData is ErrorModel && attendanceData is ErrorModel ) {
        if (userData.statusCode == 401 || attendanceData.statusCode ==401) {
          Navigator.pushReplacementNamed(context, '/unauthorized');

        }
      } else if (attendanceData is List<AttendanceModel>) {
        _attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
        _attendanceProvider.updateAttendanceTimes(attendanceData);
      }


      setState(() {
        _userData = userData;
        _attendanceData = attendanceData;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _fetchUserData();
  }

  _showDialog(BuildContext context, dynamic object, bool error) {
    return DialogWidget.dialogBuilder(context, object, error);
  }

  _showErrorInformation(double screenSize, dynamic object) {
    return ListViewInformation.listViewErrorBuilder(screenSize, object);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final screenSize = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DateTimeProvider()),
        ChangeNotifierProvider(
          create: (context) => AttendanceProvider(),
        ),
      ],
      child: Consumer<AttendanceProvider>(
        builder:
            (BuildContext context, AttendanceProvider attendanceProvider, _) =>
            RefreshIndicator(
              onRefresh: attendanceProvider.isLoading ? () async {} : _refreshData,
              color: Colors.redAccent,
              child: _isLoading
                  ? Center(
                child: Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  color: Colors.redAccent,
                  child: LoadingAnimationWidget.fourRotatingDots(
                      size: 90, color: Colors.white),
                ),
              )
                  : _buildContent(
                  context, screenWidth, screenSize, attendanceProvider),
            ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double screenWidth,
      Size screenSize, AttendanceProvider attendanceProvider) {
    if (_userData is UserModel || _attendanceData is List<AttendanceModel>) {
      final data = _userData as UserModel;

      return ListView(
        padding: const EdgeInsets.all(20),
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
            padding: const EdgeInsets.only(top: 20),
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
                      offset: const Offset(2, 2))
                ],
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Consumer<AttendanceProvider>(builder: (BuildContext context,
                AttendanceProvider attendanceProvider, _) {

              if (attendanceProvider.errorResult != null) {
                if (attendanceProvider.errorResult?.statusCode == 500) {
                  return _showErrorInformation(screenSize.height,
                      attendanceProvider.errorResult!.detail);
                }

                if (!attendanceProvider.isLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showDialog(context, attendanceProvider.errorResult, true);
                  });
                }
              } else if (attendanceProvider.attendanceResult != null) {
                if (!attendanceProvider.isLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showDialog(
                        context, attendanceProvider.attendanceResult, false);
                  });
                }
              }
              return Row(
                children: [
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FontStyle.buildText(
                              "Check in", screenWidth / 20, Colors.white),
                          FontStyle.buildText(
                              _attendanceProvider.chekinTime ??
                              attendanceProvider.chekinTime ?? "--/--", screenWidth / 20, Colors.white)
                        ],
                      )),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FontStyle.buildText(
                              "Check out", screenWidth / 20, Colors.white),
                          FontStyle.buildText(
                              _attendanceProvider.chekoutTime ??
                                  attendanceProvider.chekoutTime ?? "--/--", screenWidth / 20, Colors.white)
                        ],
                      ))
                ],
              );
            }),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Consumer<DateTimeProvider>(
              builder: (BuildContext context, DateTimeProvider dateTimeProvider,
                  _) =>
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
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 13),
              padding: const EdgeInsets.symmetric(vertical: 17),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.redAccent,
                    width: 1.0,
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(2, 2))
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Consumer<AttendanceProvider>(
                    builder: (BuildContext context,
                        AttendanceProvider attendanceProvider, _) {
                      if (attendanceProvider.isLoading) {
                        return SizedBox(
                          width: 300,
                          height: 320,
                          child: Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.red,
                              size: 100,
                            ),
                          ),
                        );
                      }

                      return attendanceProvider.photoFile == null
                          ? Container(
                        width: 300,
                        height: 320,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/icons/face-scan.png"))),
                      )
                          : SizedBox(
                        width: 300,
                        height: 320,
                        child: Image.file(
                          attendanceProvider.photoFile!,
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 6.5,
                  ),
                  Consumer<DateTimeProvider>(
                    builder: (BuildContext context,
                        DateTimeProvider dateTimeProvider, _) =>
                        Consumer<AttendanceProvider>(
                          builder: (BuildContext context,
                              AttendanceProvider attendanceProvider, _) =>
                              TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        const CircleBorder()),
                                    backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: attendanceProvider.isLoading
                                      ? null
                                      : () {
                                    attendanceProvider.attendance(
                                        dateTimeProvider.formattedTime
                                            .toString(),
                                        dateTimeProvider.formattedDate
                                            .toString());
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
      );
    } else if (_userData is ErrorModel || _attendanceData is ErrorModel) {
      final error = _userData as ErrorModel;
      final errorAttendance = _attendanceData as ErrorModel;

      if (error.statusCode == 500 || errorAttendance.statusCode == 500) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: screenSize.height / 1.15,
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
                      error.detail,
                      style: FontStyle.textStyle(
                          40, Colors.redAccent, FontWeight.w800),
                    ),
                    const SizedBox(height: 20,),
                    Material(
                      shape: const CircleBorder(),
                      elevation: 4.0,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const CircleBorder(),
                          ),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.5)), // Jika ingin menambahkan warna bayangan
                        ),
                        onPressed: () {
                          _refreshData();
                        },
                        child: const Icon(
                          Icons.refresh_outlined,
                          size: 50,
                          color: Colors.redAccent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }
      return Container();
    } else {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: screenSize.height / 1.15,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/bad_request.jpg',
                    width: 350,
                    height: 250,
                  ),

                  const SizedBox(height: 20,),

                  Material(
                    shape: const CircleBorder(),
                    elevation: 4.0,
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const CircleBorder(),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.5)), // Jika ingin menambahkan warna bayangan
                      ),
                      onPressed: () {
                        _refreshData();
                      },
                      child: const Icon(
                        Icons.refresh_outlined,
                        size: 50,
                        color: Colors.redAccent,
                      ),
                    ),
                  )

                ],

              ),

            ),

          ),
        ],
      );
    }
  }
}
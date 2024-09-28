import 'dart:io';
import 'package:face_recognition_application/api/fetching/attandace_fetch.dart';
import 'package:face_recognition_application/api/model/attendance_model.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceProvider with ChangeNotifier {
  File? _photoFile;
  AttendanceModel? _attendanceResult;
  ErrorModel? _errorResult;
  bool _isLoading = false, _isLoadingCam =false, _locationDeniedForever =false;
  String _action = "chekin";
  String? _lat, _long, _chekinTime,_chekoutTime, _dateTime, _error;

  File? get photoFile => _photoFile;
  AttendanceModel? get attendanceResult => _attendanceResult;
  ErrorModel? get errorResult => _errorResult;
  bool get isLoading => _isLoading;
  bool get isLoadingCam => _isLoadingCam;
  String get action => _action;
  String? get error => _error;
  String? get chekinTime => _chekinTime;
  String? get chekoutTime => _chekoutTime;
  bool? get locationDeniedForever => _locationDeniedForever;


  set action(String action) {
    _action = action;
    notifyListeners();
  }

  set photoFile(File? file) {
    _photoFile = file;
    notifyListeners();
  }

  set errorResult(ErrorModel? errorModel) {
    _errorResult = errorModel;
    notifyListeners();
  }

  set attendanceResult(AttendanceModel? attendanceModel) {
    _attendanceResult = attendanceModel;
    notifyListeners();
  }

  Future <Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return Future.error("Location services is disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("denied");

        return Future.error('Location permissions are denied');
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        _locationDeniedForever = false;
        return Future.error('Location permissions are available');
      }

      if (permission == LocationPermission.deniedForever) {
        _locationDeniedForever = true;
        print("denied forever");
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    return await Geolocator.getCurrentPosition();

  }




  Future<void> attendance(String time, String date) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token');
    final ImagePicker picker = ImagePicker();

    _dateTime =
        "${time.split(":").sublist(0, 2).join(":")},$date";


    try {
      _isLoadingCam = true;

      final location = await getCurrentLocation();
      print("lat : ${location.latitude}, long : ${location.longitude}");
      _isLoadingCam = false;

      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      final LostDataResponse response = await picker.retrieveLostData();
      // final position = getCurrentLocation();


      if (response.isEmpty) {
        if (image != null) {
          _isLoading = true;
          _error = null;
          notifyListeners();

          File imageMap = File(image.path);

          _photoFile = imageMap;


          var res = await Attendance.attendance(
              action, imageMap, _dateTime!, authToken!);


          if (res is AttendanceModel) {
            _errorResult = null;
            _attendanceResult = res;
            if (res.action == "chekin") {
              _chekinTime = (res.dateTime)?.split(",")[0];
              _action = "chekout";
            } else if(res.action == "chekout") {
              _chekoutTime = (res.dateTime)?.split(",")[0];
            }
          } else if (res is ErrorModel) {
            _attendanceResult = null;

            _errorResult = res;
          }
        }
      }
    } catch (e) {
      _error = "An error occurred during recognition: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateAttendanceTimes(List<AttendanceModel> data) {
    for (var item in data) {
      if (item.action == 'chekin') {
        print("Sudah chekin");
        _chekinTime = (item.dateTime)?.split(",")[0];

      }
      if (item.action == 'chekout') {
        print("Sudah chekout");

        _chekoutTime = (item.dateTime)?.split(",")[0];
      }
      notifyListeners();

    }
  }




}

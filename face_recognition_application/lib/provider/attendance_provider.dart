import 'dart:io';
// import 'package:face_recognition_application/api/fetching/recognition_fetch.dart';
import 'package:face_recognition_application/api/fetching/attandace_fetch.dart';
import 'package:face_recognition_application/api/model/attendance_model.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceProvider with ChangeNotifier {
  File? _photoFile;
  AttendanceModel? _attendanceResult;
  ErrorModel? _errorResult;
  bool _isLoading = false;
  bool _ignore = false;

  String? _error;
  String _action = "chekin";
  String? _dateTime;

  File? get photoFile => _photoFile;
  AttendanceModel? get attendanceResult => _attendanceResult;
  ErrorModel? get errorResult => _errorResult;
  bool get isLoading => _isLoading;

  String get action => _action;
  String? get error => _error;


  set action(String action) {
    _action = action;
    notifyListeners();
  }

  set errorResult(ErrorModel? content) {
    _errorResult = content;
    notifyListeners();
  }
  Future<void> attendance(String time, String date) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token');
    final ImagePicker picker = ImagePicker();

    _dateTime =
        "${time.split(" ")[0].split(":").sublist(0, 2).join(":")},$date";

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      final LostDataResponse response = await picker.retrieveLostData();

      if (response.isEmpty) {
        if (image != null) {
          _isLoading = true;
          _error = null;
          notifyListeners();

          File imageMap = File(image.path);

          _photoFile = imageMap;

          // User? result = await
          var res = await Attendance.attendance(
              action, imageMap, _dateTime!, authToken!);

          print(res);
          if (res is AttendanceModel) {
            _errorResult = null;
            print("berhasil 2");
            _attendanceResult = res;
          } else if (res is ErrorModel) {
            _attendanceResult = null;
            print("gagal");

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
}

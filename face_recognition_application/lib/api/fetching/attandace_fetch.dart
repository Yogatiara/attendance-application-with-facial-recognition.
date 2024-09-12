import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:face_recognition_application/api/model/attendance_model.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Attendance {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static Future<dynamic> atendance(String action, File targetFaceImage,
      String time, String date, String token) async {
    try {
      var formData = FormData.fromMap({
        'action': action,
        'target_face_image': await MultipartFile.fromFile(targetFaceImage.path),
        'time': time,
        'date': date,
      });

      var res = await Dio().post(
        "${dotenv.env["API_URL"]}/user/attendance/",
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // if (res.statusCode == 401) {
      //   final prefs = await SharedPreferences.getInstance();

      //   await prefs.remove('token');
      // }

      if (res.statusCode == 201) {
        // return AttendanceModel(token: token)
        return AttendanceModel(
            action: action,
            targetFaceImage: targetFaceImage,
            time: time,
            date: date);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode != 400 || e.response?.statusCode != 401) {
          return ErrorModel(
              statusCode: e.response?.statusCode, detail: "Server error");
        } else {
          return ErrorModel(
              statusCode: e.response?.statusCode,
              detail: e.response?.data["detail"]);
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    return null;
  }
}

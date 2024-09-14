import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:face_recognition_application/api/model/attendance_model.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Attendance {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static Future<Object?> attendance(String action, File targetFaceImage,
      String dateTime, String token) async {
    try {
      var formData = FormData.fromMap({
        'action': action,
        'target_face_image': await MultipartFile.fromFile(targetFaceImage.path),
        'date_time': dateTime,
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

      if (res.statusCode == 201) {
        print("berhasil 1");
        return AttendanceModel(
            message: res.data["message"],
            userName: res.data["data"]["user_name"],
            nim: res.data["data"]["nim"],
            action: action,
            status: res.data["data"]["status"],
            targetFaceImage: targetFaceImage,
            dateTime: dateTime);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode != 400 && e.response?.statusCode != 401
            && e.response?.statusCode != 403) {
          return ErrorModel(statusCode: 500, detail: "Server error");
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

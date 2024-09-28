import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:face_recognition_application/api/model/attendance_model.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Attendance {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static Future<dynamic> attendance(String action, File targetFaceImage,
      String dateTime, double lat, double long, String token) async {
    try {
      var formData = FormData.fromMap({
        'action': action,
        'target_face_image': await MultipartFile.fromFile(targetFaceImage.path),
        'date_time': dateTime,
        'lat' :lat,
        'long' :long,
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
        return AttendanceModel(
            message: res.data["message"],
            userName: res.data["data"]["user_name"],
            nim: res.data["data"]["nim"],
            action: res.data["data"]["action"],
            status: res.data["data"]["status"],
            targetFaceImage: targetFaceImage,
            dateTime: dateTime,
            lat: res.data["data"]["lat"],
            long: res.data["data"]["long"],
            distance: res.data["data"]["distance"],
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode != 400 && e.response?.statusCode != 401
            && e.response?.statusCode != 403) {
          return ErrorModel(statusCode: 500, detail: "Server error");
        } else {
          return ErrorModel(
              statusCode: e.response?.statusCode,
              detail: e.response?.data["detail"],
              // data: e.response?.data["detail"]["distance"],
              // dataBool: e.response?.data["detail"]["range_exception"]
          )
          ;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    return null;
  }

  static Future<dynamic> getAttendanceByDateAndAction(String date, String action, String token) async {
    try {
      Response res;

      if (action.isEmpty) {
        res = await Dio().get(
          "${dotenv.env["API_URL"]}/user/get-attendance?date=$date",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
      } else {
        res = await Dio().get(
          "${dotenv.env["API_URL"]}/user/get-attendance?date=$date&action=$action",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
      }

      if (res.statusCode == 200) {
        List<dynamic> data = res.data['data'];
        return data.map((item) =>
            AttendanceModel.fromJson(item)).toList();
      } else {
        return ErrorModel(statusCode: res.statusCode, detail: "Unexpected error occurred");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode != 401 && e.response?.statusCode != 403) {
          return ErrorModel(statusCode: 500, detail: "Server error");
        } else {
          return ErrorModel(
              statusCode: e.response?.statusCode,
              detail: e.response?.data["detail"] ?? "Unknown error"
          );
        }
      } else {
        return ErrorModel(statusCode: 500, detail: "Network error or no response");
      }
    }
  }

}

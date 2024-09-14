import 'package:dio/dio.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:face_recognition_application/api/model/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static Future<dynamic> login(int nim, String password) async {
    try {
      final res = await Dio().post(
        "${dotenv.env["API_URL"]}/user/login/",
        data: {"nim": nim, "password": password},
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (res.statusCode == 200) {
        final token = res.data["access_token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return UserModel(
            token: res.data["access_token"], message: res.data["message"]);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode != 401) {
          return ErrorModel(statusCode: 500, detail: "Server error");
        } else {
          return ErrorModel(
              statusCode: e.response?.statusCode,
              detail: e.response?.data["detail"]);
        }
      }
    }
    return null;
  }

  static Future<ErrorModel?> verifyToken(String token) async {
    try {
      final res = await Dio().get(
        "${dotenv.env["API_URL"]}/user/verify-token/",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // if (res.statusCode == 200) {

      // }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode != 401) {
          return ErrorModel(
              statusCode: e.response?.statusCode, detail: "Server error");
        } else {
          return ErrorModel(
              statusCode: e.response?.statusCode,
              detail: e.response?.data["detail"]);
        }
      }
    }
    return null;
  }
}

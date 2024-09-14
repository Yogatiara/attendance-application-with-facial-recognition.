import 'package:dio/dio.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:face_recognition_application/api/model/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class User {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static Future<dynamic> getUser(String token) async {
    try {
      final res = await Dio().get(
        "${dotenv.env["API_URL"]}/user/get-user/",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (res.statusCode == 200) {
        return UserModel(
            userId: res.data["data"]["user_id"],
            userName: res.data["data"]["username"],
            message: res.data["message"]);
      }
    } on DioException catch (e) {
      if (e.response != null) {
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
    }
  }
}

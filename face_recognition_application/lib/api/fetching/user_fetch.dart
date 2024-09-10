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
      final res = await Dio().post(
        "${dotenv.env["API_URL"]}/user/get-user/",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (res.statusCode == 200) {
        return UserModel(
            userId: res.data["data"]["user_id"], message: res.data["message"]);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // return ErrorModel(
        //     statusCode: e.response?.data["status_code"],
        //     detail: e.response?.data["detail"]);
      }
    }
  }
}

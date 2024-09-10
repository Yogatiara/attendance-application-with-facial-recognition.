import 'package:dio/dio.dart';
import 'package:face_recognition_application/api/model/verify_token_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class VerifyToken {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static Future<VerifyTokenModel?> verifToken(String token) async {
    try {
      final res = await Dio().post(
        "${dotenv.env["API_URL"]}/user/verify-token/",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (res.statusCode == 200) {
        // return {
        //   'success': true,
        //   'data': res.data["data"],
        // };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // return {
        //   'success': false,
        //   'message': e.response?.data['detail'],
        // };
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    return null;
  }
}

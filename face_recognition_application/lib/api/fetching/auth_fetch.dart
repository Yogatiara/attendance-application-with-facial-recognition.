import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Auth {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static Future<Map<String, dynamic>?> login(int nim, String password) async {
    try {
      final res = await Dio().post(
        "${dotenv.env["API_URL"]}/users/login/",
        data: {"nim": nim, "password": password},
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return {
        'success': true,
        'data': res.data,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['detail'],
        };
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    return null;
  }
}

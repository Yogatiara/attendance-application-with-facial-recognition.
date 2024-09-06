import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:face_recognition_application/api/model/person_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Recognition {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static Future<Person?> runRecognition(File photoFile) async {
    try {
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(photoFile.path),
      });

      var res = await Dio()
          .post("${dotenv.env["API_URL"]}recognition/", data: formData);

      if (res.statusCode == 201) {
        print("Response Data: ${res.data}");
        return Person(
          name: res.data["name"],
          nim: res.data["NIM"],
        );
      } else {
        throw Exception('Failed to recognize face');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // static Future<void> uploadPhoto(
  //     File photoFile, String name, String nim) async {
  //   try {
  //     var formData = FormData.fromMap({
  //       'file': await MultipartFile.fromFile(photoFile.path),
  //     });
  //     await Dio().post("http://192.168.98.163:8000/upload/", data: formData);
  //   } catch (e) {
  //     log(e.toString()); // Log the exception for debugging
  //   }
  // }
}

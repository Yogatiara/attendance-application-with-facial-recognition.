import 'package:face_recognition_application/api/fetching/user_fetch.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:face_recognition_application/api/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _username;
  Object? _res;

  String? get username => _username;

  set username(String? username) {
    _username = username;
  }

  Future<void> getUser() async {
    print("test");

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token');
    Object? res = await User.getUser(authToken!);

    if (res is UserModel) {
      print(res.userName);
    } else if (res is ErrorModel) {
      print(res.detail);
    }
    notifyListeners();
  }
}

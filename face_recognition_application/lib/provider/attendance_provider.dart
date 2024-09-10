import 'dart:io';
// import 'package:face_recognition_application/api/fetching/recognition_fetch.dart';
import 'package:face_recognition_application/api/fetching/attandace_fetch.dart';
import 'package:face_recognition_application/api/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceProvider with ChangeNotifier {
  File? _photoFile;
  Map<String, dynamic>? _result;
  bool _isLoading = false;
  String? _error;
  String _action = "chek_in";
  // Person? _person;

  File? get photoFile => _photoFile;
  Map<String, dynamic>? get result => _result;
  bool get isLoading => _isLoading;
  String get action => _action;
  String? get error => _error;

  set action(String action) {
    _action = action;
    notifyListeners();
  }

  Future<void> attendance(String action, String timeStamp) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token');
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    final LostDataResponse response = await picker.retrieveLostData();

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      final LostDataResponse response = await picker.retrieveLostData();

      if (response.isEmpty) {
        if (image != null) {
          File imageMap = File(image.path);

          _photoFile = imageMap;
          // User? result = await

          // if (result != null) {
          //   _person = result;
          // } else {
          //   _error = "Recognition failed: No result returned.";
          // }
        } else {
          _error = "No image selected.";
        }
      }
    } catch (e) {
      _error = "An error occurred during recognition: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    notifyListeners();
  }
}

import 'dart:io';
import 'package:face_recognition_application/api/fetching/recognition_fetch.dart';
import 'package:face_recognition_application/api/model/person_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionProvider with ChangeNotifier {
  File? _photoFile;
  Person? _person;
  bool _isLoading = false;
  String? _error;

  File? get photoFile => _photoFile;
  Person? get person => _person;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> recognition() async {
    final ImagePicker picker = ImagePicker();

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
          Person? result = await Recognition.runRecognition(imageMap);

          if (result != null) {
            _person = result;
          } else {
            _error = "Recognition failed: No result returned.";
          }
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
  }
}

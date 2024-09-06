import 'package:face_recognition_application/api/fetching/recognition_fetch.dart';
import 'package:face_recognition_application/screens/attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  XFile? _image;
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _submitForm() async {
    final String name = _nameController.text;
    final String nim = _nimController.text;

    if (_image != null && name.isNotEmpty && nim.isNotEmpty) {
      await uploadPhoto(File(_image!.path), name, nim);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AttendanceScreen(), // Kirim parameter id
        ),
      );
    } else {
      // Handle the error (e.g., show a message)
      print("Please fill in all fields and upload an image");
    }
  }

  static Future<void> uploadPhoto(
      File photoFile, String name, String nim) async {
    try {
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(photoFile.path),
        'name': name,
        'nim': nim,
      });
      var res = await Dio()
          .post("http://192.168.137.10:8000/upload/", data: formData);

      // Print response status and headers for debugging
      print("Status Code: ${res.statusCode}");
      print("Response Headers: ${res.headers}");
      print("Response Data: ${res.data}");
    } catch (e) {
      print(e.toString()); // Log the exception for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Image'),
            ),
            if (_image != null) ...[
              SizedBox(height: 16),
              Image.file(
                File(_image!.path),
                height: 200,
                fit: BoxFit.cover,
              ),
            ],
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nimController,
              decoration: InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

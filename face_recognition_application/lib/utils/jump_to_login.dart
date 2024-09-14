import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

jumpToLogin(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');  // Hapus token sebelum navigasi
  if (context.mounted) {
    Navigator.pushReplacementNamed(context, '/login');
  }

}